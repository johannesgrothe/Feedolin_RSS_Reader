//
//  FeedParser.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 04.11.20.
//

import Foundation
import XMLCoder

class FeedParser {

    private var data: String?
    
    private var url_protocol: String?
    private var main_url: String?
    private var sub_url: String?
    
    func fetchData(url: String) -> Bool {
        
        // Check URL
        let result_group = getRegexGroups(for: "(https?://)([^:^/]*)(:\\d*)?(.*)?", in: url)
        if !result_group.isEmpty {
            let parsed_url_goup = result_group[0]
            self.url_protocol = parsed_url_goup[1]
            self.main_url = parsed_url_goup[2]
            
            var buf_sub_url = parsed_url_goup[4]
            buf_sub_url.remove(at: buf_sub_url.startIndex)
            self.sub_url = buf_sub_url
            
            if url_protocol == "" || main_url == "" || sub_url == "" {
                print("Parts of the URL are missing")
                return false
            }
        } else {
            print("Couldn't split URL propperly")
            return false
        }
        
        if let buf_url = URL(string: url) {
            do {
                let result = try String(contentsOf: buf_url)
                self.data = result
                return true
            } catch {
                // contents could not be loaded
                print("Loading data not successful")
                return false
            }
        } else {
            // the URL was bad!
            print("The URL somehow was still broken after checking")
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
        
        struct XMLArticle: Codable {
            let title: String
            let description: String
            let thumbnail: String?
            let link: String
            let pubDate: String
            let guid: String
        }
        
        guard let data = article_str.data(using: .utf8) else { return nil }

        let art_data = try? XMLDecoder().decode(XMLArticle.self, from: data)
        
        if art_data == nil {
            return nil
        }
        
        var art_pub_date: Date?
        
        // Create date from ISO8601 string
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: art_data!.pubDate)
        if date == nil {
            print("Error parsing date: '\(art_data!.pubDate)'")
            art_pub_date = Date()
        } else {
            art_pub_date = date!
        }
        
        return ArticleData(article_id: art_data!.guid, title: art_data!.title, description: art_data!.description, link: art_data!.link, pub_date: art_pub_date!, author: nil, parent_feed: nil)
    }
    
    func parseData() -> FetchedFeedInfo? {
        if data == nil {
            print("Cannot parse: no data fetched")
            return nil
        }
        
        if url_protocol == nil || main_url == nil || sub_url == nil {
            print("Cannot parse: no legal url data found")
            return nil
        }
        
        struct RSSChannelMeta: Codable {
            let title: String
            let link: String
            let description: String
            let language: String
        }
        
        struct RSSDoc: Codable {
            let rss: String
        }
        
        struct RSSChannel: Codable {
            let channel: String
        }

        // RSS parse
        guard let checked_data = data!.data(using: .utf8) else {
            print("Parsing failed: illegal encoding")
            return nil
        }
        
        let rss_doc = try? XMLDecoder().decode(RSSDoc.self, from: checked_data)

        if rss_doc == nil {
            print("Parsing failed: no legal rss feed document")
            print(data!)
            return nil
        }
        if rss_doc!.rss == "" {
            print("Parsing failed: empty rss feed document")
            return nil
        }
        // RSS parse end
        
        // Channel parse
        guard let checked_rss = rss_doc!.rss.data(using: .utf8) else {
            print("Parsing failed: illegal encoding")
            return nil
        }
        
        let channel_data = try? XMLDecoder().decode(RSSChannel.self, from: checked_rss)
        
        if channel_data == nil {
            print("Parsing failed: no channel found")
            return nil
        }
        if channel_data!.channel == "" {
            print("Parsing failed: empty channel found")
            return nil
        }
        // Channel parse end
        
        // Meta parse
        guard let checked_channel = channel_data!.channel.data(using: .utf8) else {
            print("Parsing failed: illegal encoding")
            return nil
        }
        
        let meta_data = try? XMLDecoder().decode(RSSChannelMeta.self, from: checked_channel)
        
        if meta_data == nil {
            print("Parsing failed: couldn't parse meta data")
            return nil
        }
        
        var article_data: [ArticleData] = []
        
        // Load Feeds
        let result = getRegexMatches(for: "<item(.+?)</item>", in: data!)
        if !result.isEmpty {
            for article_str in result {
                
                let buf_art = parseArticle(article_str)
                if buf_art != nil {
                    article_data.append(buf_art!)
                }
            }
        } else {
            print("No article data fetched")
        }
        
        let news_feed = NewsFeedMeta(title: meta_data!.title, description: meta_data!.description, language: meta_data!.language, url_protocol: url_protocol!, main_url: main_url!, sub_url: sub_url!)
        
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
