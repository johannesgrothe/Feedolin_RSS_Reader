//
//  FeedDetector.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 31.12.20.
//

import Foundation

extension String {
    
    
    /// Removes a certain amount of characters from the beginning of the string
    /// - Parameter count: amount of characters that should be removed
    /// - Returns: The modified string
    func chopPrefix(_ count: UInt = 1) -> String {
        return substring(from: self.index(startIndex, offsetBy: Int(count)))
    }

    /// Removes a certain amount of characters from the end of the string
    /// - Parameter count: amount of characters that should be removed
    /// - Returns: The modified string
    func chopSuffix(_ count: UInt = 1) -> String {
        return substring(to: self.index(endIndex, offsetBy: -Int(count)))
    }
}

class FeedDetector: ObservableObject {
    @Published var detected_feeds: [NewsFeedMeta]
    
    @Published var specific_feed: NewsFeedMeta?
    
    @Published var is_scanning: Bool
    
    private var current_url_private: SplittedURLParts?
    
    private var pendingUpdateProcess: DispatchWorkItem?
    private var pendingUpdateID = UUID()
    
    private var pendicUpdateSpecificProcess: DispatchWorkItem?
    private var pendingUpdateSpecificID = UUID()
    
    var url: SplittedURLParts? {
        get {
            return current_url_private
        }
    }
    
    init() {
        detected_feeds = []
        current_url_private = nil
        is_scanning = false
        specific_feed = nil
    }
    
    func detect(_ url: String, deep_scan: Bool = false) {
        
        if url == "" {
            // Cancel update if its still active
            if pendingUpdateProcess != nil {
                print("Canceling pending update process")
                pendingUpdateProcess!.cancel()
            }
            self.pendingUpdateID = UUID()
            self.pendingUpdateSpecificID = UUID()
            
            self.current_url_private = nil
            self.is_scanning = false
            self.detected_feeds = []
            return
        }
        
        // Cancel update if its still active
        if pendicUpdateSpecificProcess != nil {
            print("Canceling pending update process")
            pendicUpdateSpecificProcess!.cancel()
        }
        
        pendicUpdateSpecificProcess = DispatchWorkItem {
            
            let local_specific_id = UUID()
            self.pendingUpdateSpecificID = local_specific_id
            
            // Buffer for found feed
            var found_local_feed: NewsFeedMeta? = nil
            
            // Load feed
            let helper_parser = FeedParser()
            if helper_parser.fetchData(url: url) {
                let data = helper_parser.parseData(feeds_only: true)
                if data != nil {
                    found_local_feed = data!.feed_info
                }
            }
            
            if local_specific_id == self.pendingUpdateSpecificID {
                // Save found feed
                DispatchQueue.main.async {
                    self.specific_feed = found_local_feed
                }
            } else {
                print("ID is no longer valid, skipping update")
            }
            
            // Reset own thread
            self.pendicUpdateSpecificProcess = nil
        }
        
        DispatchQueue.global(qos: .utility).async(execute: pendicUpdateSpecificProcess!)
        

        let detected_url = analyzeURL(url)
        
        if detected_url != nil && (detected_url != current_url_private || deep_scan) {
            current_url_private = detected_url
            print("New URL detected: \(current_url_private!.full_url)")
            
            // Cancel update if its still active
            if pendingUpdateProcess != nil {
                print("Canceling pending update process")
                pendingUpdateProcess!.cancel()
            }
            
            // Create "thread"
            pendingUpdateProcess = DispatchWorkItem {
                
                let local_update_id = UUID()
                self.pendingUpdateID = local_update_id
                
                print("Starting scan for feeds...")
                DispatchQueue.main.sync {
                    self.is_scanning = true
                }
                var buf_detected_feeds: [NewsFeedMeta] = []
                if !deep_scan {
                    buf_detected_feeds = self.detectFeeds(self.current_url_private!.full_url, shallow_scan: true)
                } else {
                    buf_detected_feeds = self.detectFeeds(self.current_url_private!.full_url, deep_scan: true)
                }
                
                if local_update_id == self.pendingUpdateID {
                    DispatchQueue.main.sync {
                        print("Searching finished")
                        self.is_scanning = false
                        self.detected_feeds = buf_detected_feeds
                        self.pendingUpdateProcess = nil
                    }
                } else {
                    print("ID is no longer valid, skipping update")
                }

            }
            
            // Start "thread"
            DispatchQueue.global(qos: .utility).async(execute: pendingUpdateProcess!)
        }
    }
    
    
    /// Method to analyze an URL and split it into its parts
    /// - Parameter input_str: string to get the url from
    /// - Returns: The splittet parts of the url
    func analyzeURL(_ input_str: String) -> SplittedURLParts? {
        let url = detectURL(input_str)
        if url == nil {
            return nil
        }
        
        print("Found URL: \(url!)")
        
        let small_url_pattern = "([a-z0-9]+).([a-z]{2,})/"
        let small_url_pattern_co = "([a-z0-9]+).(co.[a-z]{2,3})/"
        let co_pattern = "(co.[a-z]{2,3})"
        let protocol_pattern = "^([a-z0-9]+?)://.+?"
        
        var test_url = url!.lowercased().trimmingCharacters(in: [" "])
        
        if test_url.contains(" ") {
            return nil
        }
        
        let protocol_result = getRegexGroups(for: protocol_pattern, in: test_url)
        var url_prot = ""
        if !protocol_result.isEmpty {
            url_prot = protocol_result[0][0]
        }

        if !test_url.contains("/") {
            test_url = test_url + "/"
        }
        
        if !test_url.contains("//") {
            test_url = "//" + test_url
        }
        
        var local_small_pattern = small_url_pattern
        if !getRegexGroups(for: co_pattern, in: test_url).isEmpty {
            local_small_pattern = small_url_pattern_co
        }
        
        let small_result = getRegexGroups(for: local_small_pattern, in: test_url)
        if small_result.isEmpty {
            return nil
        }
        let main_url = small_result[0][0]
        let url_ending = small_result[0][1]
        
        let sub_pattern = "//([a-z0-9\\.]+?)\\.\(main_url)"
        let sub_result = getRegexGroups(for: sub_pattern, in: test_url)
        var sub_url = ""
        if !sub_result.isEmpty {
            sub_url = sub_result[0][0]
        }
        
        var url_path = ""
        let path_pattern = "\(url_ending)/(.*)"
        let path_result = getRegexGroups(for: path_pattern, in: test_url)
        if !path_result.isEmpty {
            url_path = path_result[0][0]
        }
        
        if url_prot == "" {
            url_prot = "https"
        }
        
        if sub_url == "" {
            sub_url = "www"
        }
        
        return SplittedURLParts(url_protocol: url_prot,
                                sub_url: sub_url,
                                main_url: main_url,
                                url_region: url_ending,
                                url_path: url_path)
    }
    
    
    /// Method to detect an url in a string
    /// - Parameter url: the string to get the url from
    /// - Returns: The url
    func detectURL(_ url: String) -> String? {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: url, options: [], range: NSRange(location: 0, length: url.utf16.count))

        for match in matches {
            guard let range = Range(match.range, in: url) else { continue }
            let found_url = url[range]
            return found_url.lowercased()
        }
        return nil
    }
    
    /// Function that receives an URL start (like 'https://www.nzz.ch/') and a html source code and scans it for links to rss feeds. The URL is used to add it if the found links are relative links.
    /// - Parameters:
    ///   - url_start: Main url of the site that is searched (like 'https://www.nzz.ch/')
    ///   - source_code: source code of any sub.site of the passed url
    /// - Returns: A list of links to the detected feeds
    private func detectFeedsInSourcecode(_ url_start: String, source_code: String) -> [String] {
        
        var found_urls: [String] = []
        
        /** Search for .rss namings in text */
        let found_mentions_rss = getRegexGroups(for: "(http[s]?)://(.+?)\\.rss", in: source_code)
        
        for found_rss_group in found_mentions_rss {
            found_urls.append("\(found_rss_group[0])://\(found_rss_group[1]).rss")
        }
        
        /** Search for .rss links */
        let found_urls_rss = getRegexGroups(for: "href=\"(.+?)\\.rss\"", in: source_code)
        
        for found_rss_group in found_urls_rss {
            found_urls.append(found_rss_group[0]+".rss")
        }
        
        /** Search for .xml feeds */
        let found_urls_xml = getRegexGroups(for: "href=\"(.+?)\\.xml\"", in: source_code)
        
        for found_xml_group in found_urls_xml {
            found_urls.append(found_xml_group[0]+".xml")
        }
        
        let main_url_has_slash = url_start.hasSuffix("/")
        
        var valid_urls: [String] = []
        
        for raw_found_url in found_urls {
            var found_url = raw_found_url
            
            if main_url_has_slash {
                found_url = found_url.trimmingCharacters(in: ["/"])
            }
            
            
            if (found_url.hasSuffix(".rss") || found_url.hasSuffix(".xml")) && !found_url.contains("manifest") {
                var add_url = found_url
                let local_main_url = getMainURL(found_url)
                if local_main_url == nil {
                    add_url = url_start + add_url
                }
                valid_urls.append(add_url)
            }
        }
        return valid_urls
    }

    private func detectLinksInSourcecode(_ url_start: String, source_code: String) -> [String] {
        
        let found_urls = getRegexMatches(for: "\"http[s]?://.+?\"", in: source_code)
        var valid_urls: [String] = []
        
        for raw_found_url in found_urls {
            let found_url = raw_found_url.trimmingCharacters(in: ["\""])
            if found_url.hasPrefix(url_start) {
                if !(found_url.contains(".jpeg") || found_url.contains(".jpg") || found_url.contains(".png") || found_url.contains(".rss")) {
                    valid_urls.append(found_url)
                }
            }
        }
        
        return valid_urls
    }

    func detectFeeds(_ url: String, deep_scan: Bool = false, shallow_scan: Bool = false) -> [NewsFeedMeta] {
        
        let short_main_url = getMainURL(url)
        if short_main_url == nil {
            print("no main url")
            return []
        }
        
        var full_main_url = "http://www." + short_main_url!
        if url.starts(with: "https://") {
            full_main_url = "https://www." + short_main_url!
        }
        
        print("Detecting feeds from '\(full_main_url)'")
        
        
        let index_src_code = fetchHTTPData(full_main_url.lowercased())
        if index_src_code == nil {
            print("Could not load index data")
            return []
        }
        
        /** List with urls to scan, filled with every fitting url found on the main page */
        var search_urls: [String] = []
        search_urls = detectLinksInSourcecode(full_main_url, source_code: index_src_code!)

        /** List with URLs already searched */
        var old_search_urls: [String] = []
        
        /** List of all detected feeds */
        var found_feed_list: [String] = []
        
        var prioritized_urls: [String] = []
        
        for i_url in search_urls {
            if (i_url.contains("feed") && !i_url.contains("feedback")) || i_url.contains("rss") {
                prioritized_urls.append(i_url)
                found_feed_list.append(i_url)
            }
        }
        
        /** Go through prioritized URLs in the found-list and scan it */
        for search_url in prioritized_urls {
            old_search_urls.append(search_url)

            let src_code = fetchHTTPData(search_url.lowercased())
            if src_code != nil {
                let local_feeds: [String] = detectFeedsInSourcecode(full_main_url, source_code: src_code!)
                
                for feed_url in local_feeds {
                    if !found_feed_list.contains(feed_url) {
                        found_feed_list.append(feed_url)
                    }
                }
            }
        }
        
        if !shallow_scan && (deep_scan || prioritized_urls.isEmpty) {
            /** Go through every URL in the found-list and scan it */
            for search_url in search_urls {
                old_search_urls.append(search_url)

                let src_code = fetchHTTPData(search_url.lowercased())
                if src_code != nil {
                    let local_feeds: [String] = detectFeedsInSourcecode(full_main_url, source_code: src_code!)
                    
                    for feed_url in local_feeds {
                        if !found_feed_list.contains(feed_url) {
                            found_feed_list.append(feed_url)
                        }
                    }
                }
            }
        }
        
        // Print searched urls
        print("Searched:")
        for link in old_search_urls {
            print("- \(link)")
        }
        
        // Print found feeds
        print("Feeds Found (\(found_feed_list.count)):")
        if found_feed_list.count > 0 {
            for feed in found_feed_list {
                print("- \(feed)")
            }
        } else {
            print("None")
        }
        
        var out_feed_data: [NewsFeedMeta] = []
        
        for feed_url in found_feed_list {
            let helper_parser = FeedParser()
            if helper_parser.fetchData(url: feed_url) {
                let data = helper_parser.parseData(feeds_only: true)
                if data != nil {
                    let local_feed_data = data!.feed_info
                    var add = true
                    for stored_feed_data in out_feed_data {
                        if stored_feed_data.complete_url == local_feed_data.complete_url {
                            add = false
                            break
                        }
                    }
                    if add {
                        out_feed_data.append(local_feed_data)
                    }
                }
            }
        }

        return out_feed_data
    }
}

func getMainURL(_ url: String) -> String? {
    let complete_url = url.lowercased()
    
    // Check URL
    let result_group = getRegexGroupsOldDontUse(for: "(https?://)([a-z0-9]+)\\.([^:^/]*)(:\\d*)?(.*)?", in: complete_url)
    if !result_group.isEmpty {
        let parsed_url_goup = result_group[0]
        let main_url = parsed_url_goup[3]
        
        if main_url == "" {
            return nil
        }
        
        return main_url
    } else {
        return nil
    }
}

/**
 Gets all regex groups from the selected regex and the passed text.
 DO NOT USE ANYMORE IT'S SHIT
 */
private func getRegexGroupsOldDontUse(for regex: String, in text: String) -> [[String]] {
    do {
        let regex = try NSRegularExpression(pattern: regex, options: .dotMatchesLineSeparators)
        let matches = regex.matches(in: text,
                                    range: NSRange(text.startIndex..., in: text))
        return matches.map { match in
            return (0..<match.numberOfRanges).map {
                let rangeBounds = match.range(at: $0)
                guard let range = Range(rangeBounds, in: text) else {
                    return ""
                }
                return String(text[range])
            }
        }
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }
}

struct SplittedURLParts: Equatable {
    let url_protocol: String
    let sub_url: String
    let main_url: String
    let url_region: String
    let url_path: String
    var full_url: String {
        return "\(url_protocol)://\(sub_url != "" ? "\(sub_url)." : "")\(main_url).\(url_region)/\(url_path)"
    }
    var shortened_url: String {
        return "\(main_url).\(url_region)/\(url_path)"
    }
}
