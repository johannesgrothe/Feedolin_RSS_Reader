//
//  DataStructures.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 31.10.20.
//

import Foundation
import SwiftUI
import Combine

/** Get model */
let model: Model = .shared

/** Dataset for used by the model to store article information loaded from the database or fetched from the network */
class ArticleData: Identifiable, ObservableObject, Codable, Savable {
    
    /** Listing all the properties we want to serialize. The case's in the enum are the json propertys(left side) for example "id":"value"... */
    enum CodingKeys: CodingKey {
        case id, article_id, title, description, link, pub_date, image_url, parent_feeds_ids, bookmarked, read
    }
    
    /** Unique id belong to a instance of ArticleData */
    let id: UUID
    
    /** Unique id belong to a instance of ArticleData */
    let article_id: String
    
    /** Title of an article */
    let title: String
    
    /** Description of an article */
    let description: String
    
    /** Link to an article */
    let link: String
    
    /** Published Date of an article */
    let pub_date: Date
    
    /** URL to the preview image */
    let image_url: String?
    
    /** Indicator to auto-refresh Views when Icon is changed */
    @Published private var image_loaded_indicator: AnyCancellable? = nil

    @Published var image_loaded: Bool = false
    /** Actual image to display */
    let image: AsyncImage?
    
    /** Boolean that contains case of if the article is bookmarked */
    @Published var bookmarked: Bool{
        didSet{
            self.save()
        }
    }
    
    /** Boolean that contains case of if the artice is read */
    @Published var read: Bool{
        didSet{
            self.save()
        }
    }
    
    /** List instance of NewsFeed of all the feeds that includes this article */
    @Published var parent_feeds: [NewsFeed]{
        didSet {
            self.save()
        }
    }
    
    /// Whether the Article is saved and kept after restarting or not
    private var is_permanent: Bool
    
    /** Encode function to serialize a instance of ArticleData to a json string, writes out all the properties attached to their respective key */
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        /** Save all the attributes */
        try container.encode(id, forKey: .id)
        try container.encode(article_id, forKey: .article_id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(link, forKey: .link)
        try container.encode(pub_date, forKey: .pub_date)
        try container.encode(image_url, forKey: .image_url)
        try container.encode(bookmarked, forKey: .bookmarked)
        try container.encode(read, forKey: .read)
        
        /** Create a list for the parent feeds UUIDs */
        var stored_parent_ids:[UUID] = []
        
        /** Save every parent feeds UUID into the list */
        for feed in parent_feeds{
            stored_parent_ids.append(feed.id)
        }
        
        /** Save the parent feeds UUIDs*/
        try container.encode(stored_parent_ids, forKey: .parent_feeds_ids)
    }
    
    /** Decoding constructor to deserialize the archived json data into a instance of ArticleData */
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        /** Initialize all attributes */
        id = try container.decode(UUID.self, forKey: .id)
        article_id = try container.decode(String.self, forKey: .article_id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        link = try container.decode(String.self, forKey: .link)
        pub_date = try container.decode(Date.self, forKey: .pub_date)
        image_url = try container.decode(String?.self, forKey: .image_url)
        bookmarked = try container.decode(Bool.self, forKey: .bookmarked)
        read = try container.decode(Bool.self, forKey: .read)
        is_permanent = true
        
        /** Initialize parent feed list empty*/
        parent_feeds = []
        
        /** Create AsyncImage from image url */
        if self.image_url != nil {
            /**Create and assign image*/
            self.image = AsyncImage(self.image_url!, default_image: "photo")
            
            /**Chain images objectWillChange to the indicator*/
            image_loaded_indicator = self.image!.objectWillChange.sink { _ in
                print("Triggering: Article Image loaded")
                self.image_loaded = true
                self.objectWillChange.send()
            }
        } else {
            self.image = nil
        }
        
        /** Load list of all UUIDS for the feeds */
        let local_parent_feeds_ids = try container.decode([UUID].self, forKey: .parent_feeds_ids)
                
        /** Map loaded UUIDS to Instances of Feed and save them */
        for id in local_parent_feeds_ids {
            let buf_feed = model.getFeedById(feed_id: id)
            if buf_feed != nil {
                self.parent_feeds.append(buf_feed!)
            } else {
                print("[ERROR] Tried to load unknown feed into collection!")
            }
        }
        
    }
    
    init(article_id: String, title: String, description: String, link: String, pub_date: Date, thumbnail_url: String?, parent_feeds: [NewsFeed]) {
        self.article_id = article_id
        self.title = title
        self.description = description
        self.link = link
        self.pub_date = pub_date
        self.image_url = thumbnail_url
        self.parent_feeds = parent_feeds
        self.bookmarked = false
        self.read = false
        self.is_permanent = false
        
        self.id = UUID()
        
        if self.image_url != nil {
            /**Create and assign image*/
            self.image = AsyncImage(self.image_url!, default_image: "photo")
            
            /**Chain images objectWillChange to the indicator*/
            image_loaded_indicator = self.image!.objectWillChange.sink { _ in
                print("Triggering: Article Image loaded")
                self.image_loaded = true
                self.objectWillChange.send()
            }
        } else {
            self.image = nil
        }
    }
    
    /** Get the Article's first Feed */
    func getRootParentFeed() -> NewsFeed{
        return self.parent_feeds[0]
    }
    
    /** Get a List of feeds of all the feed's of the Article */
    func getParentFeeds() -> [NewsFeed]{
        return self.parent_feeds
    }
    
    /** Adds all of the passed feeds to the articles parent feed lists */
    func addParentFeeds(_ feeds: [NewsFeed]) {
        for feed in feeds {
            addParentFeed(feed)
        }
    }

    /** Adds feed to parent feed list */
    func addParentFeed(_ feed: NewsFeed) {
        if !hasParentFeed(feed) {
            parent_feeds.append(feed)
        }
    }

    /** Checks whether the passed parent feed is a parent of the article */
    func hasParentFeed(_ feed: NewsFeed) -> Bool {
        for list_feed in parent_feeds {
            if feed.id == list_feed.id{
                return true
            }
        }
        return false
    }

    /** Function that returns a Date-/Timestamp as a String */
    func dateToString() -> String{
        return pub_date.long_date_short_time
    }
    
    /// Function that returns the timeAgoDate from pub_date as a String
    func timeAgoDateToString() -> String {
        return pub_date.relative_short_date
    }
    
    /// Activates persistence to save Article as soon as it gets changed
    func makePersistent() {
        if is_permanent != true {
            is_permanent = true
            self.save()
        }
    }
    
    /// Saves the Article to make it permanent
    func save() {
        if is_permanent {
            model.saveArticle(self)
        }
    }
    
}
