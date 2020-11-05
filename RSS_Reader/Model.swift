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
    func addArticle(_ article: ArticleData) -> Bool{
        for list_article in article_data {
            if list_article.article_id == article.article_id {
                print("id \(list_article.article_id) already in use")
                return false
            }
        }
        article_data.append(article)
        return true
    }
    
    /**
     Adds the articles from the list and returns how many were added successful
     */
    func addArticles(_ articles: [ArticleData]) -> Int {
        var added_articles = 0
        for article in articles {
            if addArticle(article) {
                added_articles += 1
            }
        }
        return added_articles
    }
    
    /**
     Gets the NewsFeedProvider for the given url
     # Example
     'www.blub.de'
     # Additional Info
     Do not include protocol 'http://' or any '/' after the url
     */
    func getFeedProviderForURL(_ url: String) -> NewsFeedProvider? {
        for feed_provider in feed_data {
            if feed_provider.url == url {
                return feed_provider;
            }
        }
        return nil
    }

}

//var model = Model()

var model = Model(
    article_data: [
        ArticleData(article_id: "sdfwer3", title: "TestArt", description: "testdescr", link: "www.blub.to", pub_date: Date(), author: "blub@web.de", parent_feed: NewsFeed(url: "/blub.rss", name: "BlubFeed", show_in_main: true, use_filters: true, image: nil)),
        ArticleData(article_id: "sdfwer4", title: "TestArt 2", description: "testdescr", link: "www.blub.to", pub_date: Date(), author: "blub@web.de", parent_feed: NewsFeed(url: "/blub.rss", name: "BlubFeed", show_in_main: true, use_filters: true, image: nil)),
        ArticleData(article_id: "sdfwer5", title: "TestArt 3", description: "testdescr", link: "www.blub.to", pub_date: Date(), author: "blub@web.de", parent_feed: NewsFeed(url: "/blub.rss", name: "BlubFeed", show_in_main: true, use_filters: true, image: nil)),
    ])
