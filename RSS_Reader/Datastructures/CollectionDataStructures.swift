//
//  CollectionDataStructur.swift
//  RSS_Reader
//
//  Created by Katharina Kühn on 18.11.20.
//

import SwiftUI
import CoreData

/**
 * Groups feeds
 */
public class Collection: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Collection> {
        return NSFetchRequest<Collection>(entityName: "Collection")
    }
    
    /**
     * Name of the collection
     */
    @NSManaged public var name: String
    
    /**
     * List of the feeds belong to the collection
     */
    @NSManaged public var feed_list: [NewsFeed]
    
    /// Whether the Collection is saved and kept after restarting or not
    private var is_permanent: Bool = false
    
    /**
     * Unique id belong to the instance of a Collection
     */
    @NSManaged public var id: UUID
    
    /**
     * Initialized a Collection
     * - Parameter name The name of the collection.
     */
    convenience init(name: String) {
        self.init()
        self.name = name
        self.feed_list = []
        self.id = UUID()
    }
    
    /**
     * adds a feed to the collection
     */
    func addFeed(_ new_feed: NewsFeed) -> Bool {
        
        for feed in feed_list {
            if feed.url == new_feed.url {
                print("Feed with the url '\(new_feed.url)' is allready part of this collection.")
                return false
            }
        }
        print("Adding feed '\(new_feed.url)' to collection '\(self.name)'")
        
        self.feed_list.append(new_feed)
        return true
    }
    
    /**
     * removes a feed from the collection
     */
    func removeFeed(_ feed_to_remove: NewsFeed) -> Bool {
        
        var i = 0
        for feed in self.feed_list {
            if feed.id == feed_to_remove.id {
                self.feed_list.remove(at: i)
                return true
            }
            i += 1
        }
        return false
    }
    
    /**
     * checks if a feed is in the feed list of the collection
     */
    func containsFeed(_ feed: NewsFeed) -> Bool {
        
        for coll_feed in feed_list {
            if (coll_feed.id == feed.id) {
                return true
            }
        }
        return false
    }
    
    /// Activates persistence to save Collection as soon as it gets changed
    func makePersistent() {
        if is_permanent != true {
            is_permanent = true
        }
    }
}
