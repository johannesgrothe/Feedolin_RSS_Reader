//
//  DataStructures.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 31.10.20.
//

import Foundation
import CoreData
import SwiftUI
import Combine

/** Dataset for used by the model to store article information loaded from the database or fetched from the network */
public class ArticleData: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleData> {
        return NSFetchRequest<ArticleData>(entityName: "ArticleData")
    }
    
    /** Unique id belong to a instance of ArticleData */
    @NSManaged public var id: UUID
    
    /** Unique id belong to a instance of ArticleData */
    @NSManaged public var article_id: String
    
    /** Title of an article */
    @NSManaged public var title: String
    
    /** Description of an article */
    @NSManaged public var desc: String
    
    /** Link to an article */
    @NSManaged public var link: String
    
    /** Published Date of an article */
    @NSManaged public var pub_date: Date
    
    /** URL to the preview image */
    @NSManaged public var image_url: String?
    
    /** Indicator to auto-refresh Views when Icon is changed */
    @Published private var image_loaded_indicator: AnyCancellable? = nil

    @Published var image_loaded: Bool = false
    
    /** Actual image to display */
    var image: AsyncImage? = nil
    
    /** Boolean that contains case of if the article is bookmarked */
    @NSManaged public var bookmarked: Bool
        
    /** Boolean that contains case of if the artice is read */
    @NSManaged public var read: Bool
    
    /** List instance of NewsFeed of all the feeds that includes this article */
    @NSManaged public var parent_feeds: [NewsFeed]
    
    /// Whether the Article is saved and kept after restarting or not
    private var is_permanent: Bool = false

    
    convenience init(article_id: String, title: String, description: String, link: String, pub_date: Date, thumbnail_url: String?, parent_feeds: [NewsFeed]) {
        self.init()
        self.article_id = article_id
        self.title = title
        self.desc = description
        self.link = link
        self.pub_date = pub_date
        self.image_url = thumbnail_url
        self.parent_feeds = parent_feeds
        self.bookmarked = false
        self.read = false
        self.is_permanent = false
        
        self.id = UUID()
        
        if self.image_url != nil {
            /**Create and assign image*/
            self.image = AsyncImage(self.image_url!, default_img: "photo")
            
            /**Chain images objectWillChange to the indicator*/
            image_loaded_indicator = self.image!.objectWillChange.sink { _ in
                print("Triggering: Article Image loaded")
                self.image_loaded = true
                self.objectWillChange.send()
            }
        }
    }
    
    /** Get the Article's first Feed */
    func getRootParentFeed() -> NewsFeed{
        return self.parent_feeds[0]
    }
    
    /** Get a List of feeds of all the feed's of the Article */
    func getParentFeeds() -> [NewsFeed]{
        return self.parent_feeds
    }
    
    /** Adds all of the passed feeds to the articles parent feed lists */
    func addParentFeeds(_ feeds: [NewsFeed]) {
        for feed in feeds {
            addParentFeed(feed)
        }
    }

    /** Adds feed to parent feed list */
    func addParentFeed(_ feed: NewsFeed) {
        if !hasParentFeed(feed) {
            parent_feeds.append(feed)
        }
    }

    /** Checks whether the passed parent feed is a parent of the article */
    func hasParentFeed(_ feed: NewsFeed) -> Bool {
        for list_feed in parent_feeds {
            if feed.id == list_feed.id{
                return true
            }
        }
        return false
    }

    /** Function that returns a Date-/Timestamp as a String */
    func dateToString() -> String{
        return pub_date.long_date_short_time
    }
    
    /// Function that returns the timeAgoDate from pub_date as a String
    func timeAgoDateToString() -> String {
        return pub_date.relative_short_date
    }
    
    /// Activates persistence to save Article as soon as it gets changed
    func makePersistent() {
        if is_permanent != true {
            is_permanent = true
        }
    }
}
