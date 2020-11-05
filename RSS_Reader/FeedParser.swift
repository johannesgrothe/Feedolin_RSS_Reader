//
//  FeedParser.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 04.11.20.
//

import Foundation

class FeedParser {
    
    private var url: String?
    
    private var data: String?
    
    func fetchData(url: String) -> Bool {
        self.url = url
        if let buf_url = URL(string: url) {
            do {
                let result = try String(contentsOf: buf_url)
                self.data = result
                return true
            } catch {
                // contents could not be loaded
                print("Loading not successful")
                return false
            }
        } else {
            // the URL was bad!
            print("Broken url")
            return false
        }
    }
    
    /**
     Finds all matches for the regex in the passed text and returns them as a list of strings
     */
    private func getRegexMatches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: .dotMatchesLineSeparators)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            
            let buf_res = results.map {
                String(text[Range($0.range, in: text)!])
            }
            return buf_res
            
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    /**
     Replaces all matches with the regex in the text with the chosen replacement and returns the new string
     */
    private func replaceRegexMatches(for regex: String, in text: String, with replacement: String) -> String? {
        
        do {
            let regex = try NSRegularExpression(pattern: regex, options: .dotMatchesLineSeparators)
            
            let replacedStr = regex.stringByReplacingMatches(in: text,
                                options: [],
                                range: NSRange(text.startIndex..., in: text),
                                withTemplate: replacement)
            
            return replacedStr
            
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func getRegexGroups(for regex: String, in text: String) -> [[String]] {
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
    
    private func parseArticle(_ article_str: String) -> ArticleData? {
        var fetch_ok = true
        
        var art_id: String
        var art_title: String
        var art_desc: String
        var art_link: String
        var art_pub_date: Date
        var art_author: String?
        
        var result = getRegexMatches(for: "<guid(.+?)>(.+?)</guid>", in: article_str)
        if !result.isEmpty {
            art_id = result[0]
        } else {
            art_id = "<err>"
            print("err getting article guid")
            print(article_str)
            fetch_ok = false
        }
        
        result = getRegexMatches(for: "<title>(.+?)</title>", in: article_str)
        if !result.isEmpty {
            art_title = result[0].replacingOccurrences(of: "<title>", with: "").replacingOccurrences(of: "</title>", with: "")
        } else {
            art_title = "<err>"
            print("err getting article title")
            fetch_ok = false
        }
        
        result = getRegexMatches(for: "<description>(.+?)</description>", in: article_str)
        if !result.isEmpty {
            art_desc = result[0].replacingOccurrences(of: "<description>", with: "").replacingOccurrences(of: "</description>", with: "")
        } else {
            art_desc = ""
        }
        
        result = getRegexMatches(for: "<link>(.+?)</link>", in: article_str)
        if !result.isEmpty {
            art_link = result[0].replacingOccurrences(of: "<link>", with: "").replacingOccurrences(of: "</link>", with: "")
        } else {
            art_link = "<err>"
            print("err getting article link")
            fetch_ok = false
        }
        
        result = getRegexMatches(for: "<pubDate>(.+?)</pubDate>", in: article_str)
        if !result.isEmpty {
            let date_str = result[0].replacingOccurrences(of: "<pubDate>", with: "").replacingOccurrences(of: "</pubDate>", with: "")
            
            // Create date from ISO8601 string
            let dateFormatter = ISO8601DateFormatter()
            let date = dateFormatter.date(from:date_str)
            if date == nil {
                print("Error parsing date: '\(date_str)'")
                art_pub_date = Date()
            } else {
                art_pub_date = date!
            }
        } else {
            art_pub_date = Date()
            print("err getting article date")
            fetch_ok = false
        }
        
        result = getRegexMatches(for: "<author>(.+?)</author>", in: article_str)
        if !result.isEmpty {
            art_author = result[0].replacingOccurrences(of: "<author>", with: "").replacingOccurrences(of: "</author>", with: "")
        } else {
            art_author = nil
        }
        
        if fetch_ok {
            let buf_art_data = ArticleData(article_id: art_id, title: art_title, description: art_desc, link: art_link, pub_date: art_pub_date, author: art_author, parent_feed: nil)
            return buf_art_data
        } else {
            print("Error fetching article from:")
            print(article_str)
            return nil
        }
    }
    
    func parseData() -> FetchedFeedInfo? {
        if data == nil {
            return nil
        }
        
        let header_only = replaceRegexMatches(for: "<item>(.+?)</item>", in: data!, with: "<_xD_>")
        
        if header_only == nil {
            print("Cannot get header")
            return nil
        }
        
        var title: String
        var description: String
        var language: String
        
        var url_protocol: String
        var main_url: String
        var sub_url:String
        
        var article_data: [ArticleData] = []
        
        var result = getRegexMatches(for: "<title>(.+?)</title>", in: header_only!)
        if !result.isEmpty {
            title = result[0].replacingOccurrences(of: "<title>", with: "").replacingOccurrences(of: "</title>", with: "")
        } else {
            return nil
        }
        
        result = getRegexMatches(for: "<description>(.+?)</description>", in: header_only!)
        if !result.isEmpty {
            description = result[0].replacingOccurrences(of: "<description>", with: "").replacingOccurrences(of: "</description>", with: "")
        } else {
            return nil
        }
        
        result = getRegexMatches(for: "<language>(.+?)</language>", in: header_only!)
        if !result.isEmpty {
            language = result[0].replacingOccurrences(of: "<language>", with: "").replacingOccurrences(of: "</language>", with: "")
        } else {
            return nil
        }
        
        // Check URL
        let result_group = getRegexGroups(for: "(https?://)([^:^/]*)(:\\d*)?(.*)?", in: url!)
        if !result_group.isEmpty {
            let parsed_url_goup = result_group[0]
            url_protocol = parsed_url_goup[1]
            main_url = parsed_url_goup[2]
            sub_url = parsed_url_goup[4]
            sub_url.remove(at: sub_url.startIndex)
            
            if url_protocol == "" || main_url == "" || sub_url == "" {
                return nil
            }
        } else {
            return nil
        }
        
        // Load Feeds
        result = getRegexMatches(for: "<item>(.+?)</item>", in: data!)
        if !result.isEmpty {
            for article_str in result {
                
                let buf_art = parseArticle(article_str)
                if buf_art != nil {
                    article_data.append(buf_art!)
                }
            }
        } else {
            print("No article date fetched")
        }
        
        
        let news_feed = NewsFeedMeta(title: title, description: description, language: language, url_protocol: url_protocol, main_url: main_url, sub_url: sub_url)
        
        return FetchedFeedInfo(feed_info: news_feed, articles: article_data)
    }
}

struct FetchedFeedInfo {
    let feed_info: NewsFeedMeta
    let articles: [ArticleData]
}

struct NewsFeedMeta {
    let title: String
    let description: String
    let language: String
    let url_protocol: String
    let main_url: String
    let sub_url: String
}
