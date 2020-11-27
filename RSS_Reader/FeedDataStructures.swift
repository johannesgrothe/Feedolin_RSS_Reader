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

    enum CodingKeys: CodingKey {
        case id, url, name, token, icon, feeds
    }

   func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(url, forKey: .url)
        try container.encode(name, forKey: .name)
        try container.encode(token, forKey: .token)
        try container.encode(icon, forKey: .icon)
        try container.encode(feeds, forKey: .feeds)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id)
        url = try container.decode(String.self, forKey: .url)
        name = try container.decode(String.self, forKey: .name)
        token = try container.decode(String.self, forKey: .token)
        icon = try container.decode(NewsFeedIcon.self, forKey: .icon)
        feeds = try container.decode([NewsFeed].self, forKey: .feeds)
    }

    init(url: String, name: String, token: String, icon: NewsFeedIcon, feeds: [NewsFeed]) {
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
    
    /**
     Returns the feed for the given UUID
     */
    func getFeedById(id: UUID) -> NewsFeed? {
        for feed in feeds {
            if feed.id == id {
                return feed
            }
        }
        return nil
    }


    func getId() -> UUID {
        return self.id
    }

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
    @Published var name: String
    
    /**
     Short version (Abkürzung)
     */
    @Published var token: String
    
    /**
     Indicator to auto-refresh Views when Icon is changed
     */
    private var icon_loaded_indicator: AnyCancellable? = nil

    /**
     Icon of the Feed provider
     */
    @Published var icon: AsyncImage

    /**
     List of all news feeds
     */
    @Published var feeds: [NewsFeed]
}

/**
 Class that represents a newsfeed
 */
class NewsFeed: Codable, Identifiable, ObservableObject {

    enum CodingKeys: CodingKey {
        case id, url, name, show_in_main, use_filters, provider_id, provider, image
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(url, forKey: .url)
        try container.encode(name, forKey: .name)
        try container.encode(show_in_main, forKey: .show_in_main)
        try container.encode(use_filters, forKey: .use_filters)
        try container.encode(provider_id, forKey: .provider_id)
        try container.encode(image, forKey: .image)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id)
        url = try container.decode(String.self, forKey: .url)
        name = try container.decode(String.self, forKey: .name)
        show_in_main = try container.decode(Bool.self, forKey: .show_in_main)
        use_filters = try container.decode(Bool.self, forKey: .use_filters)
        provider_id = try container.decode(UUID.self, forKey: .provider_id)
        image = try container.decode(FeedTitleImage?.self, forKey: .image)
        parent_feed = nil
    }

    init(url: String, name: String, show_in_main: Bool, use_filters: Bool, provider_id: UUID, parent_feed: NewsFeedProvider, image: FeedTitleImage?) {
        self.url = url
        self.name = name
        self.show_in_main = show_in_main
        self.use_filters = use_filters
        self.provider_id = provider_id
        self.parent_feed = parent_feed
        self.image = image
        self.id = UUID.init()
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
    @Published var name: String
    
    /**
     Determines whether the articles fetched from that source should be shown in the main feed
     */
    @Published var show_in_main: Bool
    
    /**
     Determines whether any of the selected filters should be applied
     */
    @Published var use_filters: Bool
    
    /**
     Parent feed of the news feed
     */
    var parent_feed: NewsFeedProvider?

    let provider_id: UUID
    
    /**
     Optional title image for the feed
     */
    let image: FeedTitleImage?
}

/**
 Icon for an feed provider
 */
struct NewsFeedIcon: Codable {
    enum CodingKeys: CodingKey{
        case url
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(url, forKey: .url)
    }

    let url: String
}

/**
 Title-image for an feed
 */
struct FeedTitleImage: Codable {

    enum CodingKeys: CodingKey {
        case url, title
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(url, forKey: .url)
        try container.encode(title, forKey: .title)
    }

    let url: String
    let title: String?
}
