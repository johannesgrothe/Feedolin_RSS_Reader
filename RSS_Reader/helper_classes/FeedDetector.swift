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


/// Function that receives an URL start (like 'https://www.nzz.ch/') and a html source code and scans it for links to rss feeds. The URL is used to add it if the found links are relative links.
/// - Parameters:
///   - url_start: Main url of the site that is searched (like 'https://www.nzz.ch/')
///   - source_code: source code of any sub.site of the passed url
/// - Returns: A list of links to the detected feeds
private func detectFeeds(_ url_start: String, source_code: String) -> [String] {
    
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
    
    print("found \(found_urls.count) feeds")
    print(found_urls)
    
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

private func detectLinks(_ url_start: String, source_code: String) -> [String] {
    
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

func detect_feeds(_ url: String, deep_scan: Bool = false, shallow_scan: Bool = false) -> [NewsFeedMeta] {
    
    let short_main_url = getMainURL(url)
    if short_main_url == nil {
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
    search_urls = detectLinks(full_main_url, source_code: index_src_code!)

    /** List with URLs already searched */
    var old_search_urls: [String] = []
    
    /** List of all detected feeds */
    var found_feed_list: [String] = []
    
    var prioritized_urls: [String] = []
    
    for i_url in search_urls {
        if (i_url.contains("feed") && !i_url.contains("feedback")) || i_url.contains("rss") {
            prioritized_urls.append(i_url)
        }
    }
    
    /** Go through prioritized URLs in the found-list and scan it */
    for search_url in prioritized_urls {
        old_search_urls.append(search_url)

        let src_code = fetchHTTPData(search_url.lowercased())
        if src_code != nil {
            let local_feeds: [String] = detectFeeds(full_main_url, source_code: src_code!)
            
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
                let local_feeds: [String] = detectFeeds(full_main_url, source_code: src_code!)
                
                for feed_url in local_feeds {
                    if !found_feed_list.contains(feed_url) {
                        found_feed_list.append(feed_url)
                    }
                }
            }
        }
    }
    
    print(found_feed_list.count)
    print("Searched:")
    for link in old_search_urls {
        print("- \(link)")
    }
    print("Feeds Found:")
    for feed in found_feed_list {
        print("- \(feed)")
    }
    return []
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

func getMainURL(_ url: String) -> String? {
    let complete_url = url.lowercased()
    
    // Check URL
    let result_group = getRegexGroupsOldDontUse(for: "(https?://)([a-z0-9]+)\\.([^:^/]*)(:\\d*)?(.*)?", in: complete_url)
    if !result_group.isEmpty {
        let parsed_url_goup = result_group[0]
        let main_url = parsed_url_goup[3]
        
        if main_url == "" {
            print("Parts of the URL are missing")
            return nil
        }
        
        return main_url
    } else {
        print("Couldn't split URL propperly")
        return nil
    }
}
