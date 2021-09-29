//
//  NewsFeedProvider+CoreDataClass.swift
//  RSS_Reader
//
//  Created by Emircan Duman on 29.09.21.
//
//

import Foundation
import CoreData
import SwiftUI
import Combine

public class NewsFeedProvider: NSManagedObject, Identifiable {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsFeedProvider> {
        return NSFetchRequest<NewsFeedProvider>(entityName: "NewsFeedProvider")
    }
    
    @NSManaged public var feeds: [NewsFeed]
    @NSManaged public var icon: AsyncImage
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var token: String
    @NSManaged public var url: String
    
    /**
     Indicator to auto-refresh Views when Icon is changed
     */
    @Published private var icon_loaded_indicator: AnyCancellable? = nil
    
    /// Whether the Feed Provider is saved and kept after restarting or not
    private var is_permanent: Bool = false
    
    /**
     List storing indicators to update the FeedProvider when any Feed is updated
     */
    @Published private var feed_updated_indicators: [AnyCancellable?] = []
    
    /**
     Constructor for the feed
     */
    convenience init(url: String, name: String, token: String, icon_url: String, feeds: [NewsFeed]) {
        self.init()
        self.url = url
        self.name = name
        self.token = token
        self.feeds = feeds
        self.id = UUID.init()
        
        var default_icon: String = ""
        let prefix = String(token.lowercased().prefix(1))
        
        if prefix.isAlphanumeric {
            default_icon = token.lowercased().prefix(1) + ".circle"
        } else {
            default_icon = "questionmark.circle"
        }
        
        /**
         Google-API for getting an icon for the url
         */
        self.icon = AsyncImage("https://www.google.com/s2/favicons?sz=64&domain_url=\(url)", default_img: default_icon)
        
        /**
         the icon_loaded_indicator is 'chained' to the images 'objectWillChange'
         This way, the NewsFeedProvider is changing as soon as the image is changing, updating
         every connected view in the process
         */
        icon_loaded_indicator = icon.objectWillChange.sink { _ in
            print("Triggering: Feed Provider Icon loaded")
            self.objectWillChange.send()
        }
    }
    
    /**
     Adds a feed to the feed provider if a feed with the same url does not already exist
     */
    func addFeed(feed: NewsFeed) -> Bool {
        for list_feed in feeds {
            if list_feed.url == feed.url {
                print("Failed to add '\(feed.url)' to '\(url)'")
                return false
            }
        }
        print("Adding '\(feed.url)' to '\(url)'")
        
        self.feeds.append(feed)
        
        /**Link update of the feed to the feed provider*/
        feed_updated_indicators.append(icon.objectWillChange.sink { _ in
            print("Triggering: Feed has changed")
            self.objectWillChange.send()
        })
        
        return true
    }
    
    /**
     Returns the feed for the given url
     */
    func getFeed(url: String) -> NewsFeed? {
        for feed_data in feeds {
            if feed_data.url == url {
                return feed_data
            }
        }
        return nil
    }
    
    func makePersistent() {
        if is_permanent != true {
            is_permanent = true
        }
    }
    
}
