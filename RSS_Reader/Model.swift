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
            return "All"
        case .Collection(let collection):
            return collection.name
        case .FeedProvider(let feed_provider):
            return feed_provider.name
        case .Feed(let feed):
            return feed.parent_feed!.token.description + " - " + feed.name
        case .Bookmarked:
            return "Bookmarked"
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
    
    /**Path property to the directory where all the NewFeedProvider json's are saved*/
    let feed_providers_path = getPathURL(directory_name: "FeedProviders")

    /**Path property to the directory where all the ArticleData json's are saved*/
    let articles_path = getPathURL(directory_name: "Articles")

    /**Path property to the directory where all the Collection json's are saved*/
    let collections_path = getPathURL(directory_name: "Collections")

    /**
     Singleton for the Model.

     Use '@ObservedObject var model: Model = .shared' to access model in views.
     */
    static let shared = Model()
    
    /** A function that checks if the app is launched first time on the ios device. If the app gets deleted and reinstalled this will reset it self*/
    func isAppAlreadyLaunchedOnce(){
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce") {
            print("App already launched")
        } else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            collection_data.insert(contentsOf: [
                Collection(name: "Politik")
                ,Collection(name: "Wirtschaft")
                ,Collection(name: "Technik")
                ,Collection(name: "Gaming")
                ,Collection(name: "Unterhaltung")
            ], at: 0)
            print("App launched first time")
        }
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
                
                // Fetch new articles from this and every other feed
                fetchFeeds()

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
        
        // Counter for the added articles
        var fetched_articles = 0
        
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
                                fetched_articles += 1
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
        print("New articles fetched: \(fetched_articles)")

        // Refresh viewed articles if any new artices were fetched
        if fetched_articles != 0 {
            refreshFilter()
            saveData()
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

        // Sort all the filtered articles by date
        sortArticlesByDate()
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
    
    /**Generates a path to the IOS app storage of this app and generates for all DataStructers an own direcotry where the instance of the objects can be saved as json data.
     ( A path where you can read and write your app's files there without worrying about colliding with other apps).
     */
    static func getPathURL(directory_name: String) -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = paths[0].appendingPathComponent("\(directory_name)")
        let path_string = path.path
        let fileManager = FileManager.default

        do{
            try fileManager.createDirectory(atPath: path_string, withIntermediateDirectories: true, attributes: nil)
        } catch   {
            print("error")
        }
        print(path.absoluteURL)
        return path
    }

    /**Writes in the given path a json data from a given json_string and names it after the given file_name*/
    private func writeObjectStringToJsonFile(path: URL, json_string: String, file_name: String){
        let filename = path.appendingPathComponent("\(file_name).json")
        do {
            try json_string.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("failed to write file")
        }
    }

    /** saves all the Instances of our objects in the right order to avoid conflicts */
    func saveData(){
        save(path: feed_providers_path)
        save(path: collections_path)
        print("Saving Data")
    }

    /**
     Saves all the Instances of our objects, function knows wich object to save by checking given path
     - Parameter path: The path of the files that are supposed to be saved. The path also contains the information WHICH files are supposed to be saved.
     */
    private func save(path: URL){
        
        /** Delete all files that are nor representing any alive object */
        cleanupStoredFiles()
        
        let json_encoder = JSONEncoder()

        switch path.pathComponents[path.pathComponents.count-1] {
        case "FeedProviders":
            for feed_provider in feed_data{
                let json_data = try! json_encoder.encode(feed_provider)
                let json_string = String(data: json_data, encoding: String.Encoding.utf8)!
                writeObjectStringToJsonFile(path: path, json_string: json_string, file_name: feed_provider.id.uuidString)
            }
        case "Collections":
            for collection in collection_data{
                let json_data = try! json_encoder.encode(collection)
                let json_string = String(data: json_data, encoding: String.Encoding.utf8)!
                writeObjectStringToJsonFile(path: path, json_string: json_string, file_name: collection.id.uuidString)
            }
        default:
            print("ERROR: Path = \(path.pathComponents[path.pathComponents.count-1]) not supported")
        }
    }

    /** loades all the Instances of our objects in the right order to avoid conflicts */
    func loadData() {
        print("Loading Data")
        load(path: feed_providers_path)
        load(path: articles_path)
        load(path: collections_path)
        print("Loading Data OK")
    }

    /**
     Loades all the Instances of our objects, function knows wich object to load by checking given path
     - Parameter path: Path to the folder the files should be loaded from
     */
    private func load(path: URL){
        let fileManager = FileManager.default
        let decoder = JSONDecoder()

        do {
            let items = try fileManager.contentsOfDirectory(atPath: path.path)
            for item in items{
                let item_path = "\(path)\(item)"
                let json_data = try Data(contentsOf: URL(string:item_path)!)

                switch path.pathComponents[path.pathComponents.count-1] {
                case "FeedProviders":
                    /** Deserialize FeedProvider*/
                    let object = try! decoder.decode(NewsFeedProvider.self, from: json_data)
                    
                    /** Add feed provider to list */
                    feed_data.append(object)
                    
                    /**Link update of the feed to the feed provider*/
                    self.feed_provider_update_indicators.append(object.objectWillChange.sink { _ in
                        print("Triggering: Feed Provider changed")
                        self.objectWillChange.send()
                    })
                    
                case "Articles":
                    /** Deserialize Artivle */
                    let object = try! decoder.decode(ArticleData.self, from: json_data)
                    
                    /** Add article to list */
                    stored_article_data.append(object)
                    
                case "Collections":
                    /** Deserialize Collection */
                    let object = try! decoder.decode(Collection.self, from: json_data)

                    /** Add collection to list */
                    collection_data.append(object)
                    
                default:
                    print("ERROR: Path = \(path.pathComponents[path.pathComponents.count-1]) not supported")
                }
            }
        }
        catch {
            print("Failed to read Directory")
        }
    }

    /**
     Returns a Instance of NewsFeed by the NewsFeed's id
     - Parameter feed_id: ID so search for
     - Returns: The found newsfeed if there is any, nil otherwise
     */
    func getFeedById(feed_id: UUID) -> NewsFeed?{
        for feed_provider in feed_data{
            for feed in feed_provider.feeds{
                if feed_id == feed.id{
                    return feed
                }
            }
        }
        return nil
    }

        /**
     Find and deletes all files in the list contained in the superfolder.
     - Parameters:
     - path: Directory these files are located in
     - list: list with AnyObject's (for example feed_data, stored_data...)
     
                        !ATTENTION!:
     This method is Private and should only be called by @cleanupStoredFiles() and list has to be an array of ArticeData, Collection or NewsFeedProvider nothing else. Otherwise this will throw an error
     */
    private func removeFiles(path: URL, list: [AnyObject]) throws {
        
        /** Create FileManager instance */
        let file_manager = FileManager()

        /** Find files and append list of files to remove */
        do {
            /** Load all filenames at given path */
            let files = try file_manager.contentsOfDirectory(atPath: path.path)

            /**
             Initialize array for all files that should be removed.
             (cannot remove them while iterating because thats the rules and you would blow shit up)
             */
            var remove_files: [String] = []

            /** Iterate over filenames */
            for filename in files {
                var found: Bool = false

                /** Iterate over objects and check if their id fits */
                for object in list{
                    if let news_feed_provider = object as? NewsFeedProvider{
                        if news_feed_provider.id.uuidString + ".json" == filename {
                            found = true
                            break
                        }
                    } else if let article = object as? ArticleData{
                        if article.id.uuidString + ".json" == filename {
                            found = true
                            break
                        }
                    } else if let collection = object as? Collection{
                        if collection.id.uuidString + ".json" == filename {
                            found = true
                            break
                        }
                    }
                    else{
                        throw ModelErrors.WrongDataType("[ERROR] Datatype: \(type(of: object)) is wrong. Change Datatype to 'NewsFeedProvider', 'ArticleData' or 'Collection'")
                    }
                }

                /** If no id fitted, the file should be marked for deleting */
                if !found {
                    remove_files.append(filename)
                }
            }

            /** Check if theres anything to remove in the first place */
            if remove_files.count > 0 {
                print("Removing \(remove_files.count)")

                /** Iterate over all files to remove */
                for filename in remove_files {

                    /** Generate full file path */
                    let full_file_path = "\(path.path)/\(filename)"

                    if file_manager.fileExists(atPath: full_file_path) {
                        do {
                            /** Delete file */
                            try file_manager.removeItem(atPath: full_file_path)
                        }
                        catch let error as NSError {
                            print("Cannot delete File: \(error)")
                        }
                    } else {
                        print("File does not exist")
                    }

                }
            }
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }

    /** Cleans up the storage by calling removesFiles with given path and list, removing all files that are not represented by any alive feedprovider, article or collection object */
    private func cleanupStoredFiles() {
        do{
            try removeFiles(path: feed_providers_path, list: feed_data)
            try removeFiles(path: articles_path, list: stored_article_data)
            try removeFiles(path: collections_path, list: collection_data)
        }
        catch{
            print("\(error)")
        }
    }
    
    /** Set all Data in the model to empty List and after it will call @cleanupStoredFiles() to remove all the serialized json's*/
    func reset(){
        self.collection_data = []
        self.filtered_article_data = []
        self.stored_article_data = []
        self.feed_data = []
        self.filter_keywords = []
        self.feed_provider_update_indicators = []
        
        cleanupStoredFiles()
    }
    
    /**@saveArticle(_ article: ArticleData) will overwrite the given article*/
    func saveArticle(_ article: ArticleData){
        
        let json_encoder = JSONEncoder()
        let json_data = try! json_encoder.encode(article)
        let json_string = String(data: json_data, encoding: String.Encoding.utf8)!
        
        writeObjectStringToJsonFile(path: self.articles_path, json_string: json_string, file_name: article.id.uuidString)
        
        print("Article with the ID:\(article.id) got saved")
    }
    
    /**@removeFeed(_ givenFeed: NewsFeed) will remove the feed from his parents list and if the parent list is empty the parent will be removed*/
    func removeFeed(_ given_feed: NewsFeed){
        let parent_feed = given_feed.parent_feed!
        
        stored_article_data.removeAll{
            $0.hasParentFeed(given_feed)
        }
        
        parent_feed.feeds.removeAll{
            $0.id == given_feed.id
        }
        
        if parent_feed.feeds.isEmpty{
            feed_data.removeAll{
                $0.id == parent_feed.id
            }
        }
        
        self.cleanupStoredFiles()
    }
    
}

var preview_model = Model(
    article_data: [
        ArticleData(article_id: "sdfwer3", title: "Lorem ipsum dolor sit amet", description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua.", link: "www.blub.to", pub_date: Date().addingTimeInterval(-15000), thumbnail_url: nil, parent_feeds: [NewsFeed(url: "https://www.nzz.ch/wirtschaft.rss", name: "Wirtschaft News and more", show_in_main: true, use_filters: false, parent_feed: NewsFeedProvider(url: "https://www.nzz.ch", name: "nzz.ch", token: "nzz.ch", icon_url: "", feeds: []), image: FeedTitleImage(url: "", title: ""))]),

        ArticleData(article_id: "sdfwer4", title: "Lorem ipsum dolor sit amet, consectetur adipisici elit,", description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", link: "www.blub.to", pub_date: Date().addingTimeInterval(-450000), thumbnail_url: nil, parent_feeds: [NewsFeed(url: "https://www.nzz.ch/wirtschaft.rss", name: "Wirtschaft News and more", show_in_main: true, use_filters: false, parent_feed: NewsFeedProvider(url: "https://www.nzz.ch", name: "nzz.ch", token: "nzz.ch", icon_url: "", feeds: []), image: FeedTitleImage(url: "", title: ""))]),

        ArticleData(article_id: "sdfwer5", title: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua.", description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat.", link: "www.blub.to", pub_date: Date().addingTimeInterval(-1500), thumbnail_url: nil, parent_feeds: [NewsFeed(url: "https://www.nzz.ch/wirtschaft.rss", name: "Wirtschaft News and more", show_in_main: true, use_filters: false, parent_feed: NewsFeedProvider(url: "https://www.nzz.ch", name: "nzz.ch", token: "nzz.ch", icon_url: "", feeds: []), image: FeedTitleImage(url: "", title: ""))]),
    ])
