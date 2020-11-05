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
            // Check if article exists
            if list_article.article_id == article.article_id {
                print("id \(list_article.article_id) already in use")
                
                // Add FeedProviders of the article that was supposed to be added to the existing article
                list_article.addParentFeeds(article.parent_feeds)
                
                return false
            }
        }
        article_data.append(article)
        return true
    }
    
    func getArticle(_ id: String) -> ArticleData? {
        for article in article_data {
            if article.article_id == id {
                return article
            }
        }
        return nil
    }
    
    /**
     Adds new feed to the model
     */
    func addFeed(url: String) {
        // Parser to fetch data from the selected url
        let parser = FeedParser()
        
        // Chechs the URL, fetches data and returns if operation was successfull
        if parser.fetchData(url: url) {
            let parsed_feed_info = parser.parseData()
            
            // Check if parsing was successful
            if parsed_feed_info != nil {
                let feed_meta = parsed_feed_info!.feed_info
                
                // Get possible parent feed
                var parent_feed = model.getFeedProviderForURL(feed_meta.main_url)
                
                if parent_feed == nil {
                    parent_feed = NewsFeedProvider(web_protocol: feed_meta.url_protocol, url: feed_meta.main_url, name: feed_meta.main_url, token: feed_meta.main_url, icon: NewsFeedIcon(url: ""), feeds: [])
                    model.feed_data.append(parent_feed!)
                }
                
                var sub_feed = parent_feed?.getFeed(url: feed_meta.sub_url)
                
                if sub_feed == nil {
                    sub_feed = NewsFeed(url: feed_meta.sub_url, name: feed_meta.title, show_in_main: true, use_filters: false, parent_feed: parent_feed!, image: nil)
                }
                
                let add_successful = parent_feed!.addFeed(feed: sub_feed!)
                
                if !add_successful {
                    print("Feed with url '\(feed_meta.main_url)'/'\(feed_meta.sub_url)' altready exists")
                    return
                }
                
                for article in parsed_feed_info!.articles {
                    article.addParentFeed(sub_feed!)
                }
                
                let added_feeds = addArticles(parsed_feed_info!.articles)
                
                print("Added \(added_feeds) of \(parsed_feed_info!.articles.count) feeds to \(parent_feed!.url)/\(sub_feed!.url)")
                
            } else {
                print("Parsing Feed failed")
            }
        } else {
            print("Loading data from URL failed")
        }
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
    
    /**
     Fetches new articles from all saved news feeds
     */
    func fetchFeeds() {
        print("Fetching new articles...")
        let parser = FeedParser()
        var added_feeds = 0
        for feed_provider in feed_data {
            for feed in feed_provider.feeds {
                let feed_url = feed_provider.web_protocol + feed_provider.url + "/" + feed.url
                if parser.fetchData(url: feed_url) {
                    let feed_data = parser.parseData()
                    if feed_data != nil {
                        let feed_articles = feed_data!.articles
                        for article in feed_articles {
                            
                            article.addParentFeed(feed)
                            
                            if addArticle(article) {
                                added_feeds += 1
                            } else {
                                let existing_article = getArticle(article.article_id)
                                existing_article?.addParentFeed(feed)
                            }
                        }
                    } else {
                        print("Parsing '\(feed_url)' failed")
                    }
                } else {
                    print("Fetching '\(feed_url)' failed")
                }
            }
        }
        print("New articles fetched: \(added_feeds)")
    }
}

//var model = Model()

var model = Model(
    article_data: [
        ArticleData(article_id: "sdfwer3", title: "TestArt", description: "testdescr", link: "www.blub.to", pub_date: Date(), author: "blub@web.de", parent_feeds: []),
        
        ArticleData(article_id: "sdfwer4", title: "TestArt 2", description: "testdescr", link: "www.blub.to", pub_date: Date(), author: "blub@web.de", parent_feeds: []),
        
        ArticleData(article_id: "sdfwer5", title: "TestArt 3", description: "testdescr", link: "www.blub.to", pub_date: Date(), author: "blub@web.de", parent_feeds: []),
    ])
