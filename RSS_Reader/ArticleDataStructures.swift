//
//  DataStructures.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 31.10.20.
//

import Foundation
import SwiftUI

/**
 Dataset for used by the model to store article information loaded from the database or fetched from the network
 */
class ArticleData: Identifiable, ObservableObject, Codable {
    
    /**
     Listing all the properties we want to serialize. The case's in the enum are the json propertys(left side) for example "id":"value"...
     */
    enum CodingKeys: CodingKey {
        case id, article_id, title, description, link, pub_date, author, parent_feeds_ids
    }
    
    /**
     Encode function to serialize a instance of ArticleData to a json string, writes out all the properties attached to their respective key
     */
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var stored_parent_ids:[UUID] = []
        for feed in parent_feeds{
            stored_parent_ids.append(feed.id)
        }
        try container.encode(id, forKey: .id)
        try container.encode(article_id, forKey: .article_id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(link, forKey: .link)
        try container.encode(pub_date, forKey: .pub_date)
        try container.encode(author, forKey: .author)
        try container.encode(stored_parent_ids, forKey: .parent_feeds_ids)
    }
    
    /**
     Decoding constructor to deserialize the archived json data into a instance of ArticleData
     */
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        article_id = try container.decode(String.self, forKey: .article_id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        link = try container.decode(String.self, forKey: .link)
        pub_date = try container.decode(Date.self, forKey: .pub_date)
        author = try container.decode(String?.self, forKey: .author)
        parent_feeds_ids = try container.decode([UUID].self, forKey: .parent_feeds_ids)
        parent_feeds = []
        
        switch Int.random(in: ClosedRange<Int>(uncheckedBounds: (0,3))) {
        case 0:
            self.image = Image("824cf0bb-20a4-4655-a50e-0e6ff7520d0f")
        case 1:
            self.image = Image("c9f82579-efeb-4ed5-bf07-e10edafc3a4d")
        default:
            self.image = nil
        }
    }
    
    init(article_id: String, title: String, description: String, link: String, pub_date: Date, author: String?, parent_feeds: [NewsFeed]) {
        self.article_id = article_id
        self.title = title
        self.description = description
        self.link = link
        self.pub_date = pub_date
        self.author = author
        self.parent_feeds = parent_feeds
        
        switch Int.random(in: ClosedRange<Int>(uncheckedBounds: (0,3))) {
        case 0:
            self.image = Image("824cf0bb-20a4-4655-a50e-0e6ff7520d0f")
        case 1:
            self.image = Image("c9f82579-efeb-4ed5-bf07-e10edafc3a4d")
        default:
            self.image = nil
        }
        self.id = UUID.init()
        self.parent_feeds_ids = []
        for feed in parent_feeds{
            parent_feeds_ids.append(feed.id)
        }
    }
    
    /**Unique id belong to a instance of ArticleData*/
    let id: UUID
    
    /**Unique id belong to a instance of ArticleData*/
    let article_id: String
    
    /**Title of an article*/
    let title: String
    
    /**Description of an article*/
    let description: String
    
    /**Link to an article*/
    let link: String
    
    /**Published Date of an article*/
    let pub_date: Date
    
    /**Author of an article*/
    let author: String?
    
    /**List with id's of all the feeds that includes this article*/
    var parent_feeds_ids: [UUID]
    
    let image: Image?
    
    /**List instance of NewsFeed of all the feeds that includes this article*/
    @Published var parent_feeds: [NewsFeed]
    
    /**get the Article's first Feed*/
    func getRootParentFeedID() -> NewsFeed{
        return self.parent_feeds[0]
    }
    
    /**get a List of feeds of all the feed's of the Article */
    func getParentFeedsID() -> [NewsFeed]{
        return self.parent_feeds
    }
    
    /**
     Adds all of the passed feeds to the articles parent feed lists
     */
    func addParentFeeds(_ feeds: [NewsFeed]) {
        for feed in feeds {
            addParentFeed(feed)
        }
    }

    /**
     Adds feed to parent feed list
     */
    func addParentFeed(_ feed: NewsFeed) {
        if !hasParentFeed(feed) {
            parent_feeds.append(feed)
            parent_feeds_ids.append(feed.id)
        }
    }

    /**
     Checks whether the passed parent feed is a parent of the article
     */
    func hasParentFeed(_ feed: NewsFeed) -> Bool {
        for list_feed in parent_feeds {
            if feed.id == list_feed.id && feed.provider_id == list_feed.provider_id {
                return true
            }
        }
        return false
    }

    /**
     Function that returns a Date-/Timestamp as a String
     */
    func date_to_string() -> String{
        let date_formatter = DateFormatter()
        date_formatter.dateFormat = "dd-MM-yyyy HH:mm"
        return date_formatter.string(from: pub_date)
    }
    
    /**
     Function that returns the timeAgoDate frim Date() as a String
     */
    func time_ago_date_to_string() -> String {
        
        let date_formatter = RelativeDateTimeFormatter()
        date_formatter.unitsStyle = .short
        return date_formatter.localizedString(for: pub_date, relativeTo: Date())
    }
}
