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
    
    init(article_id: String, title: String, description: String, link: String, pub_date: Date, author: String?, parent_feed: NewsFeed) {
        self.article_id = article_id
        self.title = title
        self.description = description
        self.link = link
        self.pub_date = pub_date
        self.author = author
        self.parent_feed = parent_feed
    }
    
    let article_id: String
    let title: String
    let description: String
    let link: String
    let pub_date: Date
    let author: String?
    
    let parent_feed: NewsFeed
}
