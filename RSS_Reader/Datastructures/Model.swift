//
//  Model.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 31.10.20.
//

import Foundation
import Combine

/**
 Enum containing every filter option selectable
 */
enum FilterSetting : CustomStringConvertible {
    
    /**
     Shows all Articles that have 'show_in_main' set to true
     */
    case All

    /**
     Shows only articles connected to a feed from the selected collection
     */
    case Collection(Collection)

    /**
     Only shows aretices connected to a child feed of the selected feed provider
     */
    case FeedProvider(NewsFeedProvider)

    /**
     Only shows articles connected to the selected feed
     */
    case Feed(NewsFeed)

    /**
     Only shows bookamred articles
     */
    case Bookmarked

    /**
     Custom comparator function.
     */
    static func ==(lhs: FilterSetting, rhs: FilterSetting) -> Bool {
        switch (lhs, rhs) {
        case (.All, .All):
            return true
        case (.Collection(let col1), .Collection(let col2)):
            return col1.id == col2.id
        case (.Feed(let feed1), .Feed(let feed2)):
            return feed1.id == feed2.id
        case (.FeedProvider(let feedprovider1), .FeedProvider(let feedprovider2)):
            return feedprovider1.id == feedprovider2.id
        case (.Bookmarked, .Bookmarked):
            return true
        default:
            return false
        }
    }
    
    /**
     Custom comparator function.
     */
    static func !=(lhs: FilterSetting, rhs: FilterSetting) -> Bool {
        return !(lhs == rhs)
    }
    
    /**
    Custom way to set Strings for every enum
     */
    var description: String {
        switch self {
        case .All:
            return "all_filter".localized
        case .Collection(let collection):
            return collection.name
        case .FeedProvider(let feed_provider):
            return feed_provider.name
        case .Feed(let feed):
            return feed.parent_feed!.token.description + " - " + feed.name
        case .Bookmarked:
            return "bookmarked_filter".localized
        }
    }
}

/**
 Model for the app, contains every information the views are using
 */
final class Model: ObservableObject {
    
    /**
     Default constructor
     */
    init() {
        self.stored_article_data = []
        self.feed_data = []
        self.filter_keywords = []
        self.filtered_article_data = []
        self.collection_data = []
    }
    
    /**
     Testing constructor
     - Parameter article_data: Some data to fill up the article list
     */
    init(article_data: [ArticleData]) {
        self.stored_article_data = article_data
        self.feed_data = []
        self.filter_keywords = []
        self.filtered_article_data = []
        self.collection_data = []
    }
    
    /**
     Storage for all the articles
     */
    @Published var stored_article_data: [ArticleData]
    
    /**
     Storage for all filtered artices that should be displayed in the main view
     */
    @Published var filtered_article_data: [ArticleData]

    /**
     Storage for all of the feeds
     */
    @Published var feed_data: [NewsFeedProvider]
    
    /**
      List storing indicators to update the FeedProvider when any Feed is updated
     */
    @Published private var feed_provider_update_indicators: [AnyCancellable?] = []
    
    /**
     Storage for all of the filter keywords
     */
    @Published var filter_keywords: [FilterKeyword]

    /**
     Storage for all of the collection data
     */
    @Published var collection_data: [Collection]
    
    /// Boolean that indicaties if the model is currently fetching feeds
    @Published var is_fetching: Bool = false

    /**
     * Singleton for the Model.
     * Use '@ObservedObject var model: Model = .shared' to access model in views.
     */
    static let shared = Model()
    
    /**
     * indicates if readed articles are shown or hidden in the main view
     */
    var hide_read_articles = false
    
    /**Property of Optional type Timer will call periodicaly autoRefrehs(), when runAutoRefresh() gets called
     */
    private var timer: Timer?{
        didSet{
            if oldValue != nil{
                oldValue!.invalidate()
                print("Timer is invalid now")
            }
            if self.timer == nil{
                UserDefaults.standard.setValue(false, forKey: "auto_refresh")
            }
        }
    }

    /** A function that checks if the app is launched first time on the ios device. If the app gets deleted and reinstalled this will reset it self*/
    func isAppAlreadyLaunchedOnce(){
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce") {
            print("App already launched")
        } else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
        }
    }
    
    /// Adds a new collection to the model
    /// - Parameter collection: Collection to add
    /// - Returns: Whether adding the collection was successful
    func addCollection(_ collection: Collection) -> Bool {
        self.collection_data.append(collection)
        collection.makePersistent()
        return true
    }
    
    /**
     Adds an article to the database after checking if it already exists
     - Parameter article: The article thats supposed to be added
     - Returns: Whether adding the article was successful
     */
    private func addArticle(_ article: ArticleData) -> Bool {
        for list_article in stored_article_data {
            // Check if article exists
            if list_article.article_id == article.article_id {
                print("id \(list_article.article_id) already in use")
                
                // Add FeedProviders of the article that was supposed to be added to the existing article
                list_article.addParentFeeds(article.parent_feeds)

                return false
            }
        }
        stored_article_data.append(article)
        article.makePersistent()
        return true
    }
    
    /**
     Adds articles that are not altrady present to the storage
     - Parameter articles: The articles that are supposed to be added
     - Returns: How many articles were added
     */
    private func addArticles(_ articles: [ArticleData]) -> Int {
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
     Returns the article for the given id
     - Parameter id: The id of the article that is wanted
     - Returns: A the article data  if one is found, nil otherwiese
     */
    private func getArticle(_ id: String) -> ArticleData? {
        for article in stored_article_data {
            if article.article_id == id {
                return article
            }
        }
        return nil
    }
    
    func addFeed(feed_meta: NewsFeedMeta) -> Bool {
        let lower_url = feed_meta.complete_url.lowercased()
        
        // Get possible parent feed
        var parent_feed = self.getFeedProviderForURL(feed_meta.main_url)
        
        // Create parent feed if it doesnt already exist and add it to model
        if parent_feed == nil {
            parent_feed = NewsFeedProvider(url: feed_meta.main_url, name: feed_meta.main_url, token: feed_meta.main_url, icon_url: "https://cdn2.iconfinder.com/data/icons/social-icon-3/512/social_style_3_rss-256.png", feeds: [])
            self.feed_data.append(parent_feed!)
            parent_feed!.makePersistent()
            
            /**Link update of the feed to the feed provider*/
            self.feed_provider_update_indicators.append(parent_feed!.objectWillChange.sink { _ in
                print("Triggering: Feed Provider changed")
                self.objectWillChange.send()
            })
            
        }
        
        // Get possible sub-feed
        var sub_feed = parent_feed!.getFeed(url: lower_url)
        
        // Create sub-feed if it doesnt altrady exist and add it to parent feed
        if sub_feed == nil {
            sub_feed = NewsFeed(url: lower_url, name: feed_meta.title, show_in_main: true, use_filters: false, parent_feed: parent_feed!)
            if !parent_feed!.addFeed(feed: sub_feed!) {
                // Should NEVER happen
                print("Something stupid happened while adding '\(lower_url)'")
                return false
            }
            
        } else {
            print("Feed with url '\(lower_url)' altready exists")
            return false
        }
        
        // Fetch new articles from this and every other feed
        fetchFeeds()

        return true
    }
    
    /**
     Adds new feed to the model
     - Parameter url: The URL of the feed thats supposed to be added
     - Returns: Whether adding the feed was successful
     */
    func addFeed(url: String) -> Bool {
        
        print("Adding Feed with URL '\(url)'")
        
        // Parser to fetch data from the selected url
        let parser = FeedParser()
        let lower_url = url.lowercased()
        
        // Chechs the URL, fetches data and returns if operation was successfull
        if parser.fetchData(url: lower_url) {
            let parsed_feed_info = parser.parseData()
            
            // Check if parsing was successful
            if parsed_feed_info != nil {
                let feed_meta = parsed_feed_info!.feed_info
                
                return addFeed(feed_meta: feed_meta)
                
            } else {
                print("Parsing Feed failed")
            }
        } else {
            print("Loading data from URL failed")
        }
        return false
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
        is_fetching = true
        DispatchQueue.global().async {

            // Parser object to get the data
            let parser = FeedParser()
            
            // Counter for the added articles
            var fetched_articles = 0
            
            for feed_provider in self.feed_data {
                for feed in feed_provider.feeds {
                    if parser.fetchData(url: feed.url) {
                        let feed_data = parser.parseData()
                        if feed_data != nil {
                            let feed_articles = feed_data!.articles
                            for article in feed_articles {
                                
                                // Execute code in the main Queue
                                DispatchQueue.main.sync {
                                    // Add the parent feed to the article
                                    article.addParentFeed(feed)
                                    // Adds the article to the database, moves over the parent feeds if it already exists
                                    if self.addArticle(article) {
                                        fetched_articles += 1
                                    } else {
                                        let existing_article = self.getArticle(article.article_id)
                                        existing_article?.addParentFeed(feed)
                                    }
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
            print("New articles fetched: \(fetched_articles)")

            // Refresh viewed articles if any new artices were fetched
            if fetched_articles != 0 {
                // Execute code in the main Queue
                DispatchQueue.main.sync {
                    self.refreshFilter()
                    //self.cleanupStoredFiles()
                }
            }
            DispatchQueue.main.sync {
                self.is_fetching = false
            }
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
     Stores the last selected filter option to got back if necessary
     */
    private var last_filter_option: FilterSetting = .All

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
     Sets the selected filter option
     */
    private func setFilter(_ filter_option: FilterSetting) {
        // Do not save as 'new filter option' when its just another search phrase
        if filter_option != last_filter_option {

            // Save present filter option as 'last'
            last_filter_option = stored_filter_option
        }

        // Set new filter option
        stored_filter_option = filter_option
    }

    /**
     Sets the filter to 'All'. Every feed, that has the 'show in main feed'-flag set will be shown.
     */
    func setFilterAll() {
        setFilter(.All)
    }

    /**
     Sets the filter to 'Collection'. Every feed inside of the selected collection will be shown.
     */
    func setFilterCollection(_ collection: Collection) {
        setFilter(.Collection(collection))
    }

    /**
     Sets the filter to 'Feed Provider'. Every feed, provided by the selected feed provider will be shown.
     - Parameter feed_provider:  The feed provider which articles shall be shown
     */
    func setFilterFeedProvider(_ feed_provider: NewsFeedProvider) {
        setFilter(.FeedProvider(feed_provider))
    }

    /**
     Sets the filter to 'Feed'. Only the selected feed will be shown.
     - Parameter feed: NewsFeed that should be displayed
     */
    func setFilterFeed(_ feed: NewsFeed) {
        setFilter(.Feed(feed))
    }

    /**
     Sets the filter to 'Boommarked'. Only articles bookmarked will be shown.
     */
    func setFilterBookmarked() {
        setFilter(.Bookmarked)
    }

    /**
     Switch back to the last filter option ans set the current one as 'last'
     */
    func toggleFilter() {
        setFilter(last_filter_option)
    }

    /**
     Method to apply the given filter option
     */
    private func applyFilter(_ filter_option: FilterSetting) {
        switch filter_option {
        case .All:
            print("Applying filter 'All'")
            applyFilterAll()
        case .Collection(let filter_collection):
            print("Applying filter 'Collection'")
            applyFilterCollection(filter_collection)
        case .FeedProvider(let filter_feed_provider):
            print("Applying filter 'FeedProvider'")
            applyFilterFeedProvider(filter_feed_provider)
        case .Feed(let filter_feed):
            print("Applying filter 'Feed'")
            applyFilterFeed(filter_feed)
        case .Bookmarked:
            print("Applying filter 'Bookmarked'")
            applyFilterBookmarked()
        }
    }

    /**
     Re-applies the filter so that every new feed or other changes are applied. Call this method every time you change something in the settings having something to do withthe article lsit
     */
    func refreshFilter() {
        // Resets the shown article list list
        filtered_article_data = []

        // Reapply filter
        applyFilter(stored_filter_option)

        // Removes read articles
        if hide_read_articles {
            removeReadArticles()
        }
        
        // Sort all the filtered articles by date
        sortArticlesByDate()
    }
    
    /**
     * remove read articles from @filtered_article_data
     */
    private func removeReadArticles() {
        let buf_array = filtered_article_data
        filtered_article_data = []
        
        for article in buf_array {
            if !article.read {
                self.filtered_article_data.append(article)
            }
        }
    }


    /**
     Sorts  the @filtered_article_data list by date
     */
    private func sortArticlesByDate() {
        filtered_article_data = filtered_article_data.sorted{
            $0.pub_date > $1.pub_date
        }
    }

    /**
     (Re)applies the 'All' filter.
     Sorts @filtered_article_data by the show_in_main value in feeds and updates the @filtered_article_data list
     */
    private func applyFilterAll() {
        // Fills up the filtered article list
        filtered_article_data = stored_article_data

        // Removes every entry that should not be shown in main feed
        filtered_article_data.removeAll{
            $0.parent_feeds[0].show_in_main == false
        }
    }

    /**
     (Re)applies the collection filter
     */
    private func applyFilterCollection(_ sort_collection: Collection) {
        var colls_feed_ids:[UUID] = []
        for feed in sort_collection.feed_list {
            colls_feed_ids.append(feed.id)
        }
        
        //empty the array containing all filtered articles
        filtered_article_data = []

        for article in self.stored_article_data {
            var article_feeds_ids:[UUID] = []
            for parent_feed in article.parent_feeds {
                print(parent_feed.name)
                article_feeds_ids.append(parent_feed.id)
            }
            //subtract one array from the other, to see if there are similary elements
            if Set(article_feeds_ids).intersection(Set(colls_feed_ids)).count > 0 {
                filtered_article_data.append(article)
            }
        }
    }

    /**
     (Re)applies the feed provider filter
     */
    private func applyFilterFeedProvider(_ sort_provider: NewsFeedProvider) {
        for article in self.stored_article_data {
            for parent_feed in article.parent_feeds {
                if parent_feed.parent_feed?.id == sort_provider.id {
                    self.filtered_article_data.append(article)
                    break
                }
            }
        }
    }

    /**
     (Re)applies the feed filter
     */
    private func applyFilterFeed(_ sort_feed: NewsFeed) {
        for article in self.stored_article_data {
            if article.hasParentFeed(sort_feed) {
                self.filtered_article_data.append(article)
            }
        }
    }

    /**
     (Re)applies the bookmarks filter
     */
    private func applyFilterBookmarked() {
        for article in self.stored_article_data{
            if article.bookmarked{
                self.filtered_article_data.append(article)
            }
        }
    }

    ///
    /// END OF THE FILTERING
    ///
    
    /**
     Returns a Instance of NewsFeed by the NewsFeed's id
     - Parameter feed_id: ID so search for
     - Returns: The found newsfeed if there is any, nil otherwise
     */
    func getFeedById(feed_id: UUID) -> NewsFeed? {
        for feed_provider in feed_data{
            for feed in feed_provider.feeds{
                if feed_id == feed.id{
                    return feed
                }
            }
        }
        return nil
    }
    
    func getFeedByURL(_ url: String) -> NewsFeed? {
//        print("Searching for feed with url '\(url)'")
        for feed_provider in feed_data{
            for feed in feed_provider.feeds{
                if url == feed.url {
                    return feed
                }
            }
        }
        return nil
    }

    /** Set all Data in the model to empty List and after it will call @cleanupStoredFiles() to remove all the serialized json's*/
    func reset(){
        self.collection_data = []
        self.filtered_article_data = []
        self.stored_article_data = []
        self.feed_data = []
        self.filter_keywords = []
        self.feed_provider_update_indicators = []
        self.timer = nil
    }

    /** @autoRefrehs() will fetch the feeds and refresh all Filter*/
    @objc private func autoRefresh(){
            self.fetchFeeds()
            self.refreshFilter()
            print("Model.autoRefresh() called. App did update")
    }

    /**If the @AppStore"auto_refresh" property is true, calling runAutoRefresh will declare the private optional property @timer and will call periodacally run autoRefresh(), if false property @timer will be invalidated and set to nil.
     */
    func runAutoRefresh(){
        if UserDefaults.standard.bool(forKey: "auto_refresh") && self.timer == nil{
            self.timer = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(autoRefresh), userInfo: nil, repeats: true)
            print("Model.runAutoRefresh() called. App will update automaticly")
        }
        else{
            if self.timer != nil {
                self.timer = nil
            }
            print("Model.runAutoRefresh() called. App will not update automaticly anymore")
        }
    }
}
