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
class NewsFeedProvider: Identifiable, ObservableObject {

    init(url: String, name: String, token: String, icon_url: String, feeds: [NewsFeed]) {
        self.url = url
        self.name = name
        self.token = token
        self.feeds = feeds
        
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
class NewsFeed: Identifiable, ObservableObject {
    
    init(url: String, name: String, show_in_main: Bool, use_filters: Bool, parent_feed: NewsFeedProvider, image: FeedTitleImage?) {
        self.url = url
        self.name = name
        self.show_in_main = show_in_main
        self.use_filters = use_filters
        self.parent_feed = parent_feed
        
        self.image = image
    }
    
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
    let parent_feed: NewsFeedProvider
    
    /**
     Optional title image for the feed
     */
    let image: FeedTitleImage?
}

/**
 Icon for an feed provider
 */
struct NewsFeedIcon {
    let url: String
}

/**
 Title-image for an feed
 */
struct FeedTitleImage {
    let url: String
    let title: String?
}
