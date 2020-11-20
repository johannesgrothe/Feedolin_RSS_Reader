//
//  CollectionDataStructur.swift
//  RSS_Reader
//
//  Created by Katharina Kühn on 18.11.20.
//

import SwiftUI

/**
 Groups feeds
 */
class Collection: Identifiable, ObservableObject {
    
    /**
     Initialized a Collection
     - Parameter name The name of the collection.
     */
    init(name: String) {
        self.name = name
        self.feed_list = []
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
