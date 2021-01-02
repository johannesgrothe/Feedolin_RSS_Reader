//
//  FeedDetector.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 31.12.20.
//

import Foundation

private func detect_feed_helper(_ url: String) -> [String] {
    
    let source_code = fetchHTTPData(url.lowercased())
    if source_code == nil {
        return []
    }
    
    let found_urls = getRegexMatches(for: "\"http[s]?://.+?\"", in: source_code!)
    print(found_urls)
    return found_urls
}

func detect_feeds(_ url: String) -> [NewsFeedMeta] {
    
    var main_url = get_main_url(url)
    if main_url == nil {
        return []
    }
    
    main_url = "https://www." + main_url!
    
    print("Detecting feeds from '\(main_url!)'")
    
    /** List with urls to scan */
    var search_urls = detect_feed_helper(url)
    
    /** List with URLs already searched */
    var old_search_urls: [String] = []
    
    /** List with newly found URLs to search */
    var new_search_urls: [String] = []
    
    for _ in 0...3 {
        for search_url in search_urls {
            let buf_search_urls = detect_feed_helper(search_url)
            for s_url in buf_search_urls {
                if !search_urls.contains(s_url) && !old_search_urls.contains(s_url) && !new_search_urls.contains(s_url) {
                    new_search_urls.append(s_url)
                }
            }
            old_search_urls.append(search_url)
        }
        
        search_urls = new_search_urls
        new_search_urls = []
    }
    
    print("Searched: \(old_search_urls)")
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

func get_main_url(_ url: String) -> String? {
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
