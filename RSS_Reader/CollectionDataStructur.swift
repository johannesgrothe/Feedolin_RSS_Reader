//
//  CollectionDataStructur.swift
//  RSS_Reader
//
//  Created by Katharina Kühn on 18.11.20.
//

import SwiftUI

/**
 __ToDo:__
 Create a datastructure containing the collection name and a list of all feeds inside of the collection
 Create screens (as seen in the wireframes) to add feeds to the collection
 */

class Collection: Identifiable, ObservableObject {
    
    /**
     Initialized a Collection
     */
    init(name: String, feed_list: [NewsFeed]) {
        self.name = name
        self.feed_list = feed_list
    }
    
    /**
    Name of the collection
     */
    @Published var name: String
    
    /**
     List of the feeds belong to the collection
     */
    @Published var feed_list: [NewsFeed]
}
