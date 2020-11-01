//
//  FeedDataStructures.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 31.10.20.
//

import Foundation

/**
 Class that represents a news feed provider
 */
class NewsFeedProvider {

    init(url: String, name: String, token: String, icon: NewsFeedIcon, feeds: [NewsFeed]) {
        self.url = url
        self.name = name
        self.token = token
        self.icon = icon
        self.feeds = feeds
    }
    
    /**
     Adds a feed to the feed provider
     */
    func addFeed(feed: NewsFeed) {
        self.feeds.append(feed)
    }
    
    /**
     URL of the feed proider website 'www.nzz.ch'
     # Example
     'www.nzz.ch'
     */
    let url: String
    
    /**
     Name of the feed provider
     */
    var name: String
    
    /**
     Short version (Abkürzung)
     */
    var token: String
    
    /**
     Icon of the Feed provider
     */
    let icon: NewsFeedIcon

    /**
     List of all news feeds
     */
    var feeds: [NewsFeed]
}

/**
 Class that represents a newsfeed
 */
class NewsFeed {
    
    init(url: String, name: String, show_in_main: Bool, use_filters: Bool, image: FeedTitleImage?) {
        self.url = url
        self.name = name
        self.show_in_main = show_in_main
        self.use_filters = use_filters
        
        self.image = image
    }
    
    /**
     URL of the feed
     # Example
     'feeds/wirtschaft.rss'
     */
    let url: String
    
    /**
     Name of the feed
     */
    var name: String
    
    /**
     Determines whether the articles fetched from that source should be shown in the main feed
     */
    var show_in_main: Bool
    
    /**
     Determines whether any of the selected filters should be applied
     */
    var use_filters: Bool
    
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
