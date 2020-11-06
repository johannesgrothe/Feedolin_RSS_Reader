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
final class Model: ObservableObject {
    
    /**
     Default constructor
     */
    init() {
        self.article_data = []
        self.feed_data = []
        self.filter_keywords = []
    }
    
    /**
     Testing constructor
     - Parameter article_data: Some data to fill up the article list
     */
    init(article_data: [ArticleData]) {
        self.article_data = article_data
        self.feed_data = []
        self.filter_keywords = []
    }
    
    // Storage for all the articles
    @Published var article_data: [ArticleData]
    
    // Storage for all the feeds
    @Published var feed_data: [NewsFeedProvider]
    
    // Storage for all the filter keywords
    @Published var filter_keywords: [FilterKeyword]
    
    /**
     Adds an article to the database after checking if it already exists
     - Parameter article: The article thats supposed to be added
     - Returns: Whether adding the article was successful
     */
    func addArticle(_ article: ArticleData) -> Bool {
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
    
    /**
     Returns the article for the given id
     - Parameter id: The id of the article that is wanted
     - Returns: A the article data  if one is found, nil otherwiese
     */
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
     - Parameter url: The URL of the feed thats supposed to be added
     - Returns: Whether adding the feed was successful
     */
    func addFeed(url: String) -> Bool {
        
        // Parser to fetch data from the selected url
        let parser = FeedParser()
        let lower_url = url.lowercased()
        
        // Chechs the URL, fetches data and returns if operation was successfull
        if parser.fetchData(url: lower_url) {
            let parsed_feed_info = parser.parseData()
            
            // Check if parsing was successful
            if parsed_feed_info != nil {
                let feed_meta = parsed_feed_info!.feed_info
                
                // Get possible parent feed
                var parent_feed = self.getFeedProviderForURL(feed_meta.main_url)
                
                // Create parent feed if it doesnt already exist and add it to model
                if parent_feed == nil {
                    parent_feed = NewsFeedProvider(url: feed_meta.main_url, name: feed_meta.main_url, token: feed_meta.main_url, icon: NewsFeedIcon(url: ""), feeds: [])
                    self.feed_data.append(parent_feed!)
                }
                
                // Get possible sub-feed
                var sub_feed = parent_feed!.getFeed(url: lower_url)
                
                // Create sub-feed if it doesnt altrady exist and add it to parent feed
                if sub_feed == nil {
                    sub_feed = NewsFeed(url: lower_url, name: feed_meta.title, show_in_main: true, use_filters: false, parent_feed: parent_feed!, image: nil)
                    if !parent_feed!.addFeed(feed: sub_feed!) {
                        // Should NEVER happen
                        print("Something stupid happened while adding '\(lower_url)'")
                        return false
                    }
                } else {
                    print("Feed with url '\(lower_url)' altready exists")
                    return false
                }
                
                // Add sub-feed to all articles (its the parent feed for them)
                for article in parsed_feed_info!.articles {
                    article.addParentFeed(sub_feed!)
                }
                
                // Add all articles to model
                let added_feeds = addArticles(parsed_feed_info!.articles)
                
                // Celebrate
                print("Added \(added_feeds) of \(parsed_feed_info!.articles.count) feeds to \(parent_feed!.url)/\(sub_feed!.url)")
                return true
                
            } else {
                print("Parsing Feed failed")
            }
        } else {
            print("Loading data from URL failed")
        }
        return false
    }
    
    /**
     Adds articles that are not altrady present to the storage
     - Parameter articles: The articles that are supposed to be added
     - Returns: How many articles were added
     */
    func addArticles(_ articles: [ArticleData]) -> Int {
        // Counter for the added articles
        var added_articles = 0
        
        // Add all the articles
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
     'blub.de'
     # Additional Info
     Do not include protocol 'http://' or any '/' after the url, just something looking like the example above
     
     - Parameter url: The url of the feed provider that is wanted
     - Returns: A the feed provicer if one is found, nil otherwiese
     */
    func getFeedProviderForURL(_ url: String) -> NewsFeedProvider? {
        let lower_url = url.lowercased()
        for feed_provider in feed_data {
            if feed_provider.url == lower_url {
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
        
        // Parser object to get the data
        let parser = FeedParser()
        
        // Counter for the added feeds
        var added_feeds = 0
        
        for feed_provider in feed_data {
            for feed in feed_provider.feeds {
                if parser.fetchData(url: feed.url) {
                    let feed_data = parser.parseData()
                    if feed_data != nil {
                        let feed_articles = feed_data!.articles
                        for article in feed_articles {
                            
                            // Add the parent feed to the article
                            article.addParentFeed(feed)
                            
                            // Adds the article to the database, moves over the parent feeds if it already exists
                            if addArticle(article) {
                                added_feeds += 1
                            } else {
                                let existing_article = getArticle(article.article_id)
                                existing_article?.addParentFeed(feed)
                            }
                        }
                    } else {
                        print("Parsing '\(feed.url)' failed")
                    }
                } else {
                    print("Fetching '\(feed.url)' failed")
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
