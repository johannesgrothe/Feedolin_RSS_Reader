//
//  Model.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 31.10.20.
//

import Foundation

/**
 Model for the app, contains every information the views are using
 */
struct Model {
    var article_data: [ArticleData]
    
    var feed_data: [NewsFeedProvider]
    
    var filter_keywords: [FilterKeyword]
}

var model = Model(
    article_data: [
        ArticleData(article_id: "df23uhr8wef9hg",
                    title: "Yolo",
                    description: "desc",
                    link: "www.blub.de",
                    author: "mr. yolo",
                    src_feed: UUID(),
                    pub_date: Date())
    ],
    feed_data:[
        NewsFeedProvider()
    ])
