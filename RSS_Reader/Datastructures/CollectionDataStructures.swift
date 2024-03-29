//
//  CollectionDataStructur.swift
//  RSS_Reader
//
//  Created by Katharina Kühn on 18.11.20.
//

import SwiftUI

/**
 * Groups feeds
 */
class Collection: Identifiable, ObservableObject, Codable{
    
    /**
     * Listing all the properties we want to serialize. The case's in the enum are the json propertys(left side) for example "id":"value", "name":"value"...
     */
    enum CodingKeys: CodingKey {
        case id, name, feed_id_list
    }
    
    /**
     * Name of the collection
     */
    @Published var name: String {
        didSet {
            save()
        }
    }
    
    /**
     * List of the feeds belong to the collection
     */
    @Published var feed_list: [NewsFeed] {
        didSet {
            save()
        }
    }
    
    /// Whether the Collection is saved and kept after restarting or not
    private var is_permanent: Bool
    
    /**
     * Unique id belong to the instance of a Collection
     */
    let id: UUID
    
    /**
     * Initialized a Collection
     * - Parameter name The name of the collection.
     */
    init(name: String) {
        self.name = name
        self.feed_list = []
        self.id = UUID()
        self.is_permanent = false
    }
    
    /**
     * Decoding constructor to deserialize the archived json data into a instance of Collection
     */
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        /** Load all necessary data */
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.feed_list = []
        self.is_permanent = true
        
        /** Load list of all UUIDS for the feeds */
        let local_feed_id_list = try container.decode([UUID].self, forKey: .feed_id_list)
        
        /** Get model */
        let model: Model = .shared
        
        /** Map loaded UUIDS to Instances of Feed and save them */
        for id in local_feed_id_list {
            let buf_feed = model.getFeedById(feed_id: id)
            if buf_feed != nil {
                self.feed_list.append(buf_feed!)
            } else {
                print("[ERROR] Tried to load unknown feed into collection!")
            }
        }
    }
    
    /**
     * Encode function to serialize a instance of Collection to a json string, writes out all the properties attached to their respective key
     */
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        /** Save attributes */
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        
        /** Create List for UUIDS of the Feeds */
        var local_feed_id_list: [UUID] = []
        
        /** Save UUIDs from all Feeds to list */
        for feed in self.feed_list {
            local_feed_id_list.append(feed.id)
        }
        
        /** Save list with UUIDs */
        try container.encode(local_feed_id_list, forKey: .feed_id_list)
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
            self.save()
        }
    }
    
    /// Saves the Collection to make it permanent
    func save() {
        if is_permanent {
            model.saveCollection(self)
        }
    }
}
