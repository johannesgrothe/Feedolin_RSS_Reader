//
//  DataStructures.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 31.10.20.
//

import Foundation

/**
 Dataset for used by the model to store article information loaded from the database or fetched from the network
 */
class ArticleData: Identifiable {
    
    init(article_id: String, title: String, description: String, link: String, pub_date: Date, author: String?, parent_feeds: [NewsFeed]) {
        self.article_id = article_id
        self.title = title
        self.description = description
        self.link = link
        self.pub_date = pub_date
        self.author = author
        self.parent_feeds = parent_feeds
    }

    let article_id: String
    let title: String
    let description: String
    let link: String
    let pub_date: Date
    let author: String?
    
    var parent_feeds: [NewsFeed]

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
        }
    }

    /**
     Checks whether the passed parent feed is a parent of the article
     */
    func hasParentFeed(_ feed: NewsFeed) -> Bool {
        for list_feed in parent_feeds {
            if feed.url == list_feed.url && feed.parent_feed.url == list_feed.parent_feed.url {
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
            date_formatter.timeStyle = .medium

        return date_formatter.string(from: pub_date)
    }

}
