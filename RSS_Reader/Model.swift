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
class Model {
    
    init() {
        self.article_data = []
        self.feed_data = []
        self.filter_keywords = []
    }
    
    init(article_data: [ArticleData]) {
        self.article_data = article_data
        self.feed_data = []
        self.filter_keywords = []
    }
    
    var article_data: [ArticleData]
    
    var feed_data: [NewsFeedProvider]
    
    var filter_keywords: [FilterKeyword]
    
    /**
     Adds an article to the database after checking if it already exists
     */
    func addArticle(_ article: ArticleData) {
        for list_article in article_data {
            if list_article.article_id == article.article_id {
                return;
            }
        }
        article_data.append(article)
    }
}

//var model = Model()

var model = Model(
    article_data: [
        ArticleData(article_id: "sdfwer3", title: "TestArt", description: "testdescr", link: "www.blub.to", pub_date: Date(), author: "blub@web.de", parent_feed: NewsFeed(url: "/blub.rss", name: "BlubFeed", show_in_main: true, use_filters: true, image: nil)),
        ArticleData(article_id: "sdfwer4", title: "TestArt 2", description: "testdescr", link: "www.blub.to", pub_date: Date(), author: "blub@web.de", parent_feed: NewsFeed(url: "/blub.rss", name: "BlubFeed", show_in_main: true, use_filters: true, image: nil)),
        ArticleData(article_id: "sdfwer5", title: "TestArt 3", description: "testdescr", link: "www.blub.to", pub_date: Date(), author: "blub@web.de", parent_feed: NewsFeed(url: "/blub.rss", name: "BlubFeed", show_in_main: true, use_filters: true, image: nil)),
    ])
