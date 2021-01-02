//
//  FeedParser.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 04.11.20.
//

import Foundation
import XMLCoder

func fetchHTTPData(_ url: String) -> String? {
    
    print("Fetching HTTP Data from '\(url)'")
        
    if let buf_url = URL(string: url) {
        do {
            let result = try String(contentsOf: buf_url)
            return result
        } catch {
            // contents could not be loaded
            print("Loading data not successful")
            return nil
        }
    } else {
        // the URL was bad!
        print("The URL somehow was still broken after checking")
        return nil
    }
}

/**
 Finds all matches for the regex in the passed text and returns them as a list of strings
 */
func getRegexMatches(for regex: String, in text: String) -> [String] {
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
 Gets all regex groups from the selected regex and the passed text.
 */
func getRegexGroups(for pattern: String, in text: String) -> [[String]] {
    
    var out_group: [[String]] = []
    
    let regex = try? NSRegularExpression(
      pattern: pattern
    )
    
    if let matches = regex?.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) {
        for match in matches {
            var buf_list: [String] = []
            for i in 1 ... match.numberOfRanges - 1 {
                if let buf_range = Range(match.range(at: i), in: text) {
                    let img_url = String(text[buf_range])
                    buf_list.append(img_url)
                }
            }
            out_group.append(buf_list)
        }
    }
    return out_group
}

/**
 Class to parse a rss webfeed
 */
class FeedParser {

    private var data: String?
    
    private var main_url: String?
    private var complete_url: String?
    
    /** Method that parses the thumbnail's url from the whole article (item-tag xml string) */
    private func parseThumbnailURL(from text: String) -> String? {
        
        let image_groups = getRegexGroups(for: "<media:.*?height=\"([0-9]+?)?\".*?url=\"(.+?)\".*?[/]{0,1}>", in: text)
        if !image_groups.isEmpty {
            var biggest_res: Int = -1
            var out_uri: String = ""
            for image_tuple in image_groups {
                let size = Int(image_tuple[0]) ?? 0
                
                if size > biggest_res && size < 750 {
                    biggest_res = size
                    out_uri = image_tuple[1]
                }
            }
            if biggest_res >= 0 {
                print("Found biggest image, size:\(biggest_res)")
                return out_uri
            }
            print("Found only faulty resolution info, continuing")
        }
        
        let image_urls = getRegexGroups(for: "<media:.*?url=\"(.+?)\".*?[/]{0,1}>", in: text)
        if !image_urls.isEmpty {
            print("Returning first image found")
            return image_urls[0][0]
        }
        
        let other_image_urls = getRegexGroups(for: "<enclosure.*?type=\"image/jpeg\".*?url=\"(.+?)\".*?>", in: text)
        if !other_image_urls.isEmpty {
            print("Returning first image found")
            return other_image_urls[0][0]
        }
        
        return nil
    }
    
    /**
     Parses the data out of an article xml string
     # String Structure
     "<item> ... </item>"
     */
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
        
        let article_thumbnail_url = parseThumbnailURL(from: article_str)
        
        var art_pub_date: Date?
        
        // Create date from ISO8601 string
        let isoDateFormatter = ISO8601DateFormatter()
        var date = isoDateFormatter.date(from: art_data!.pubDate)
        if date == nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss +zzzz"
            date = dateFormatter.date(from: art_data!.pubDate)
            if date == nil {
                dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
                date = dateFormatter.date(from: art_data!.pubDate)
                if date == nil {
                    print("Error parsing date: '\(art_data!.pubDate)'")
                    art_pub_date = Date()
                } else {
                    art_pub_date = date!
                }
            } else {
                art_pub_date = date!
            }
        } else {
            art_pub_date = date!
        }
        
        return ArticleData(article_id: art_data!.guid, title: art_data!.title, description: art_data!.description, link: art_data!.link, pub_date: art_pub_date!, thumbnail_url: article_thumbnail_url, parent_feeds: [])
    }
    
    /**
     Parses the data out of an channel xml string
     # String Structure
     "<channel> ... </channel>"
     */
    private func parseChannel(_ channel_str: String) -> FetchedFeedInfo? {
        
        struct RSSChannelMeta: Codable {
            let title: String
            let link: String
            let description: String
            let language: String
        }
        
        // Meta parse
        guard let checked_channel_str = channel_str.data(using: .utf8) else {
            print("Parsing failed: illegal encoding")
            return nil
        }
        
        let channel_data = try? XMLDecoder().decode(RSSChannelMeta.self, from: checked_channel_str)
        
        if channel_data == nil {
            print("Parsing failed: no channel found")
            return nil
        }
        // Meta parse end
        
        var article_data: [ArticleData] = []
        
        // Load Feeds
        let article_data_list = getRegexMatches(for: "<item(.+?)</item>", in: data!)
        if !article_data_list.isEmpty {
            for article_str in article_data_list {
                
                let buf_art = parseArticle(article_str)
                if buf_art != nil {
                    article_data.append(buf_art!)
                }
            }
        } else {
            print("No article data fetched")
        }
        
        let news_feed = NewsFeedMeta(title: channel_data!.title, description: channel_data!.description, language: channel_data!.language, main_url: main_url!, complete_url: complete_url!)
        
        return FetchedFeedInfo(feed_info: news_feed, articles: article_data)
    }
    
    /**
     Parses previously fetched data as an rss feed
     */
    func parseData() -> FetchedFeedInfo? {
        if data == nil {
            print("Cannot parse: no data fetched")
            return nil
        }
        
        if complete_url == nil || main_url == nil {
            print("Cannot parse: no legal url data found")
            return nil
        }
        
        let channel_str_list = getRegexMatches(for: "<channel(.+?)</channel>", in: data!)
        if !channel_str_list.isEmpty {
            if channel_str_list.endIndex == 1 {
                let channel_data = parseChannel(channel_str_list[0])
                return channel_data
            } else {
                // TODO: handle
                print("Found multiple channels in one feed")
            }
        } else {
            print("No channel data found")
        }
        
    return nil
    }
    
    /**
     Gets the data for the ressource behind the url from the webserver and returns whether that was successful
     */
    func fetchData(url: String) -> Bool {
        
        complete_url = url.lowercased()
        
        // TEST REMOVE
        // TODO
        
//        _ = detect_feeds(complete_url!)
        
        // TEST END
        
        let buf_main_url = getMainURL(complete_url!)
        
        if buf_main_url == nil {
            return false
        }
        main_url = buf_main_url
        
        let buf_data = fetchHTTPData(complete_url!)
        
        if buf_data == nil {
            return false
        }
        
        self.data = buf_data
        
        return true
    }
}

/**
 Return container of the fetch operation. Contains feed meta information and an list of articles
 */
struct FetchedFeedInfo {
    let feed_info: NewsFeedMeta
    let articles: [ArticleData]
}

/**
 Raw meta information for an feed
 */
struct NewsFeedMeta {
    let title: String
    let description: String
    let language: String
    let main_url: String
    let complete_url: String
}
