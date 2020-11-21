//
//  Model.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 31.10.20.
//

import Foundation

/**
 Enum containing every filter option selectable
 */
enum FilterSetting {
    case All
    case Collection
    case FeedProvider
    case Feed
    case SearchPhrase
    case Bookmarked
}

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
        self.filtered_article_data = []
        self.collection_data = [
            Collection(name: "Politik")
            ,Collection(name: "Wirtschaft")
            ,Collection(name: "Technik")
            ,Collection(name: "Gaming")
            ,Collection(name: "Unterhaltung")
        ]
    }
    
    /**
     Testing constructor
     - Parameter article_data: Some data to fill up the article list
     */
    init(article_data: [ArticleData]) {
        self.article_data = article_data
        self.feed_data = []
        self.filter_keywords = []
        self .filtered_article_data = []
        self.collection_data = []
    }
    
    // Storage for all the articles
    @Published var article_data: [ArticleData]
    
    // Storage for all the feeds
    @Published var feed_data: [NewsFeedProvider]
    
    // Storage for all the filter keywords
    @Published var filter_keywords: [FilterKeyword]
    
    // Storage for all filtered articles
    @Published var filtered_article_data: [ArticleData]
    // Storage for all the filter keywords
    @Published var collection_data: [Collection]
    
    // Model Singleton
    static let shared = Model()
    
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
     Sorts @article_data and assigns it to the @filtered_article_data list
     */
    func sortArticlesByDate(){
        filtered_article_data = article_data.sorted{
            $0.pub_date > $1.pub_date
        }
    }
    
    /**
     Sorts @filtered_article_data by the show_in_main value in feeds and updates the @filtered_article_data list
     */
    func sortArticlesByShowInMain(){
        sortArticlesByDate()
        filtered_article_data.removeAll{
            $0.parent_feeds[0].show_in_main == false
        }
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
                    parent_feed = NewsFeedProvider(url: feed_meta.main_url, name: feed_meta.main_url, token: feed_meta.main_url, icon_url: "https://cdn2.iconfinder.com/data/icons/social-icon-3/512/social_style_3_rss-256.png", feeds: [])
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
                sortArticlesByDate()
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
    private func getFeedProviderForURL(_ url: String) -> NewsFeedProvider? {
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
        
        // Refresh viewed articles if any new artices were fetched
        if added_feeds != 0 {
            refreshFilter()
        }
    }
    
    ///
    /// BEGIN OF THE FILTERING
    ///
    
    /**
     Stores the currently active filter option
     */
    private var stored_filter_option: FilterSetting = .All
    
    /**
     Stores the last selected collection to filter by. Is not nil when the stored_filter_option  is .Collection
     */
    private var selected_collection: Collection?
    
    /**
     Stores the last selected feed provider to filter by. Is not nil when the stored_filter_option  is .FeedProvider
     */
    private var selected_feed_provider: NewsFeedProvider?
    
    /**
     Stores the last selected feed to filter by.  Is not nil when the stored_filter_option  is .NewsFeed
     */
    private var selected_feed: NewsFeed?
    
    /**
     Stores the last selected filter keyword to filter by.  Is not nil when the stored_filter_option  is .SearchPhrase
     */
    private var selected_filter_keyword: String?
    
    /**
     The currently selected filter option
     */
    var filter_option: FilterSetting {
        // Only getter is defined, the property should not be set from the outside
        get {
            return stored_filter_option
        }
    }
    
    /**
     Sets the filter to 'All'. Every feed, that has the 'show in main feed'-flag set will be shown.
     */
    func setFilterAll() {
        stored_filter_option = .All
    }
    
    /**
     Sets the filter to 'Collection'. Every feed inside of the selected collection will be shown.
     */
    func setFilterCollection(_ collection: Collection) {
        stored_filter_option = .Collection
        selected_collection = collection
    }
    
    /**
     Sets the filter to 'Feed Provider'. Every feed, provided by the selected feed provider will be shown.
     - Parameter feed_provider:  The feed provider which articles shall be shown
     */
    func setFilterFeedProvider(_ feed_provider: NewsFeedProvider) {
        stored_filter_option = .FeedProvider
        selected_feed_provider = feed_provider
    }
    
    /**
     Sets the filter to 'Feed'. Only the selected feed will be shown.
     - Parameter feed: NewsFeed that should be displayed
     */
    func setFilterFeed(_ feed: NewsFeed) {
        stored_filter_option = .Feed
        selected_feed = feed
    }
    
    /**
     Sets the filter to 'SearchPhrase'. All artices will be shown if title or description contain the filter phrase.
     - Parameter search_phrase: The phrase that shouldn be searched for
     */
    func setFilterSearchPhrase(_ search_phrase: String) {
        stored_filter_option = .SearchPhrase
        selected_filter_keyword = search_phrase
    }
    
    /**
     Sets the filter to 'Boommarked'. Only articles bookmarked will be shown.
     */
    func setFilterBookmarked() {
        stored_filter_option = .Bookmarked
    }
    
    /**
     Re-applies the filter so that every new feed or other changes are applied.
     */
    func refreshFilter() {
        // Clean filter list
        // TODO
        
        // Reapply filter
        switch stored_filter_option {
        case .All:
            print("Applying filter 'All'")
        case .Collection:
            print("Applying filter 'Collection'")
            applyFilterCollection()
        case .FeedProvider:
            print("Applying filter 'FeedProvider'")
            applyFilterFeedProvider()
        case .Feed:
            print("Applying filter 'Feed'")
            applyFilterFeed()
        case .SearchPhrase:
            print("Applying filter 'SearchPhrase'")
            applyFilterSearchPhrase()
        case .Bookmarked:
            print("Applying filter 'Bookmarked'")
            applyFilterBookmarked()
        }
        
        // Sort articles by date
        // TODO
    }
    
    /**
     (Re)applies the collection filter
     */
    private func applyFilterCollection() {
        // TODO: implement
    }
    
    /**
     (Re)applies the feed provider filter
     */
    private func applyFilterFeedProvider() {
        // TODO: implement
    }
    
    /**
     (Re)applies the feed filter
     */
    private func applyFilterFeed() {
        // TODO: implement
    }
    
    /**
     (Re)applies the searchphrase filter
     */
    private func applyFilterSearchPhrase() {
        // TODO: implement
    }
    
    /**
     (Re)applies the bookmarks filter
     */
    private func applyFilterBookmarked() {
        // TODO: implement
    }
    
    ///
    /// END OF THE FILTERING
    ///
}

var preview_model = Model(
    article_data: [
        ArticleData(article_id: "sdfwer3", title: "TestArt", description: "testdescr", link: "www.blub.to", pub_date: Date(), author: "blub@web.de", parent_feeds: []),

        ArticleData(article_id: "sdfwer4", title: "TestArt 2", description: "testdescr", link: "www.blub.to", pub_date: Date(), author: "blub@web.de", parent_feeds: []),

        ArticleData(article_id: "sdfwer5", title: "TestArt 3", description: "testdescr", link: "www.blub.to", pub_date: Date(), author: "blub@web.de", parent_feeds: []),
    ])
