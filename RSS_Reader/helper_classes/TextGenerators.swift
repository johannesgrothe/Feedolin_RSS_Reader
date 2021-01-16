//
//  OutputGenerators.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 08.01.21.
//

import Foundation

/// Generates the Description for the "Remove Feed"-Alert
/// - Parameter feed: The feed that should be removed
/// - Returns: The alert text
func getWaringTextForFeedRemoval(_ feed: NewsFeed) -> String {
    let bookmarked_articles = feed.getAmountOfBookmarkedArticles()
    var out_text = "WARNING: This action will irreversible delete the feed and all of its articles."
    if bookmarked_articles != 0 {
        out_text += "\n\nYou have \(bookmarked_articles) bookmarked articles in this feed."
    }
    return out_text
}
