//
//  FeedDataStructures.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 31.10.20.
//

import Foundation
import Combine

/**
 Class that represents a news feed provider
 */
class NewsFeedProvider: Codable, Identifiable, ObservableObject{
    
    /**
     Listing all the properties we want to serialize. The case's in the enum are the json propertys(left side) for example "id":"value"...
     */
    enum CodingKeys: CodingKey {
        case id, url, name, token, icon, feeds
    }
    
    /**Unique id belong to a instance of NewsFeedProvider*/
    let id: UUID
    
    /**
     URL of the feed proider website 'www.nzz.ch'
     # Example
     'nzz.ch'
     */
    let url: String
    
    /**
     Name of the feed provider
     */
    @Published var name: String {
        didSet {
            model.saveFeedProvider(self)
        }
    }
    
    /**
     Short version (Abkürzung)
     */
    @Published var token: String {
        didSet {
            model.saveFeedProvider(self)
        }
    }
    
    /**
     Indicator to auto-refresh Views when Icon is changed
     */
    @Published private var icon_loaded_indicator: AnyCancellable? = nil
    
    /**
     Icon of the Feed provider
     */
    @Published var icon: AsyncImage
    
    /**
     List of all news feeds
     */
    @Published var feeds: [NewsFeed] {
        didSet {
            model.saveFeedProvider(self)
        }
    }
    
    /**
     List storing indicators to update the FeedProvider when any Feed is updated
     */
    @Published private var feed_updated_indicators: [AnyCancellable?] = []
    
    /**
     Encode function to serialize a instance of NewsFeedProvider to a json string, writes out all the properties attached to their respective key
     */
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(url, forKey: .url)
        try container.encode(name, forKey: .name)
        try container.encode(token, forKey: .token)
        try container.encode(icon, forKey: .icon)
        try container.encode(feeds, forKey: .feeds)
    }
    
    /**
     Decoding constructor to deserialize the archived json data into a instance of NewsFeedProvider
     */
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        url = try container.decode(String.self, forKey: .url)
        name = try container.decode(String.self, forKey: .name)
        token = try container.decode(String.self, forKey: .token)
        icon = try container.decode(AsyncImage.self, forKey: .icon)
        feeds = try container.decode([NewsFeed].self, forKey: .feeds)
        for feed in feeds{
            feed.parent_feed = self
        }
        
        /**
         the icon_loaded_indicator is 'chained' to the images 'objectWillChange'
         This way, the NewsFeedProvider is changing as soon as the image is changing, updating
         every connected view in the process
         */
        icon_loaded_indicator = icon.objectWillChange.sink { _ in
            print("Triggering: Feed Provider Icon loaded")
            self.objectWillChange.send()
        }
    }
    
    /**
     Constructor for the feed
     */
    init(url: String, name: String, token: String, icon_url: String, feeds: [NewsFeed]) {
        self.url = url
        self.name = name
        self.token = token
        self.feeds = feeds
        self.id = UUID.init()
        
        /**
         Google-API for getting an icon for the url
         */
        self.icon = AsyncImage("https://www.google.com/s2/favicons?sz=64&domain_url=\(url)", default_image: "newspaper")
        
        /**
         the icon_loaded_indicator is 'chained' to the images 'objectWillChange'
         This way, the NewsFeedProvider is changing as soon as the image is changing, updating
         every connected view in the process
         */
        icon_loaded_indicator = icon.objectWillChange.sink { _ in
            print("Triggering: Feed Provider Icon loaded")
            self.objectWillChange.send()
        }
    }
    
    /**
     Adds a feed to the feed provider if a feed with the same url does not already exist
     */
    func addFeed(feed: NewsFeed) -> Bool {
        for list_feed in feeds {
            if list_feed.url == feed.url {
                print("Failed to add '\(feed.url)' to '\(url)'")
                return false
            }
        }
        print("Adding '\(feed.url)' to '\(url)'")
        
        self.feeds.append(feed)
        
        /**Link update of the feed to the feed provider*/
        feed_updated_indicators.append(icon.objectWillChange.sink { _ in
            print("Triggering: Feed has changed")
            self.objectWillChange.send()
        })
        
        return true
    }
    
    /**
     Returns the feed for the given url
     */
    func getFeed(url: String) -> NewsFeed? {
        for feed_data in feeds {
            if feed_data.url == url {
                return feed_data
            }
        }
        return nil
    }
}

/**
 Class that represents a newsfeed
 */
class NewsFeed: Codable, Identifiable, ObservableObject {
    
    /**
     Listing all the properties we want to serialize. The case's in the enum are the json propertys(left side) for example "id":"value"...
     */
    enum CodingKeys: CodingKey {
        case id, url, name, show_in_main, use_filters, image
    }
    
    let id: UUID
    /**
     URL of the feed
     # Example
     'https://www.nzz.ch/feeds/wirtschaft.rss'
     */
    let url: String
    
    /**
     Name of the feed
     */
    @Published var name: String {
        didSet {
            if parent_feed != nil { model.saveFeedProvider(parent_feed!) }
        }
    }
    
    /**
     Determines whether the articles fetched from that source should be shown in the main feed
     */
    @Published var show_in_main: Bool {
        didSet {
            if parent_feed != nil { model.saveFeedProvider(parent_feed!) }
        }
    }
    
    /**
     Determines whether any of the selected filters should be applied
     */
    @Published var use_filters: Bool {
        didSet {
            if parent_feed != nil { model.saveFeedProvider(parent_feed!) }
        }
    }
    
    /**
     Parent feed of the news feed
     */
    var parent_feed: NewsFeedProvider?
    
    /**
     Encode function to serialize a instance of NewsFeed to a json string, writes out all the properties attached to their respective key
     */
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(url, forKey: .url)
        try container.encode(name, forKey: .name)
        try container.encode(show_in_main, forKey: .show_in_main)
        try container.encode(use_filters, forKey: .use_filters)
    }
    
    /**
     Decoding constructor to deserialize the archived json data into a instance of NewsFeed
     */
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        url = try container.decode(String.self, forKey: .url)
        name = try container.decode(String.self, forKey: .name)
        show_in_main = try container.decode(Bool.self, forKey: .show_in_main)
        use_filters = try container.decode(Bool.self, forKey: .use_filters)
        parent_feed = nil
    }
    
    init(url: String, name: String, show_in_main: Bool, use_filters: Bool, parent_feed: NewsFeedProvider) {
        self.url = url
        self.name = name
        self.show_in_main = show_in_main
        self.use_filters = use_filters
        self.parent_feed = parent_feed
        self.id = UUID.init()
        
        /** The feed ONLY gets saved when it has propperly set the feed provider, therefore it cannot be saven in the onstructor */
    }
    /**
     @getAmountOfBookmarkedArticles() will return an Integer with the current bookmarked articles of this Feed
     */
    func getAmountOfBookmarkedArticles() -> Int{
        var counter = 0
        for article in model.stored_article_data{
            if article.hasParentFeed(self) && article.bookmarked {
                counter += 1
            }
        }
        return counter
    }
    /**
     Returns a shorthanded Version of the Feedurl
     */
    func getShortURL() -> String {
        var short_url = url
        // Strings that should remove if present
        let to_delete_array = ["https://", "http://", "www.", "rss."]
        for str in to_delete_array {
            if short_url.hasPrefix(str) {
                short_url.removeFirst(str.count)
            }
        }
        return short_url
    }
}

/**
 Title-image for an feed
 */
struct FeedTitleImage: Codable {
    let url: String
    let title: String?
}
