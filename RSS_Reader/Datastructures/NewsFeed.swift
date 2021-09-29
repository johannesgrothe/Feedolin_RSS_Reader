//
//  NewsFeed+CoreDataClass.swift
//  RSS_Reader
//
//  Created by Emircan Duman on 29.09.21.
//
//

import Foundation
import CoreData
import SwiftUI

public class NewsFeed: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsFeed> {
        return NSFetchRequest<NewsFeed>(entityName: "NewsFeed")
    }

    @NSManaged public var id: UUID
    @NSManaged public var url: String
    @NSManaged public var name: String
    @NSManaged public var show_in_main: Bool
    @NSManaged public var use_filters: Bool
    @NSManaged public var parent_feed: NewsFeedProvider?
    
    convenience init(url: String, name: String, show_in_main: Bool, use_filters: Bool, parent_feed: NewsFeedProvider) {
        self.init()
        self.url = url
        self.name = name
        self.show_in_main = show_in_main
        self.use_filters = use_filters
        self.parent_feed = parent_feed
        self.id = UUID.init()
    }
    
    
    /**
     @getAmountOfBookmarkedArticles() will return an Integer with the current bookmarked articles of this Feed
     */
    func getAmountOfBookmarkedArticles() -> Int{
        var counter = 0
//        for article in model.stored_article_data{
//            if article.hasParentFeed(self) && article.bookmarked {
//                counter += 1
//            }
//        }
        return counter
    }
    
    /**
     Returns a shorthanded Version of the Feedurl
     */
    func getShortURL() -> String {
        var short_url = url
        // Strings that should remove if present
        let to_delete_array = ["https://", "http://", "www.", "rss."]
        for str in to_delete_array {
            if short_url.hasPrefix(str) {
                short_url.removeFirst(str.count)
            }
        }
        return short_url
    }
}
