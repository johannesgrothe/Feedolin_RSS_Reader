//
//  FilterDataStructures.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 31.10.20.
//

import Foundation

class FilterKeyword: ObservableObject {
    init(keywords: [String], feeds: [NewsFeed]?) {
        self.keywords = []
        if feeds == nil {
            self.feeds = []
        } else {
            self.feeds = feeds!
        }
    }
    
    let keywords: [String]
    @Published var feeds: [NewsFeed]
}
