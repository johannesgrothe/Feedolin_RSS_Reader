//
//  FeedDataStructures.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 31.10.20.
//

import Foundation

struct NewsFeedProvider {
    // URL of the feed proider website 'www.nzz.ch'
    let url: String
    
    // Name of the feed provider
    var name: String
    
    // Short version (Abkürzung)
    var token: String
    
    // Icon of the Feed provider
    let icon: NewsFeedIcon
    
    // List of all news feeds
    var feeds: [NewsFeed]
}

class NewsFeed {
    // 'feeds/wirtschaft.rss'
    let url: String
    var name: String
    let image: FeedTitleImage?
    var show_in_main: Bool
    var use_filters: Bool
    
    // TODO: Filters
    var filter_keywords: [(String, Bool)]
    
}

struct NewsFeedIcon {
    let url: String
}

/**
 Title-image for an Feed
 */
struct FeedTitleImage {
    let url: String
    let title: String?
}
