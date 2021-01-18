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
    var out_text = "\("general_warning_phrase".localized): \("feed_delete_general_text".localized)"
    if bookmarked_articles != 0 {
        out_text += "\n\n\("feed_delete_bookmarked_part_1".localized) \(bookmarked_articles) \("feed_delete_bookmarked_part_2".localized)"
    }
    return out_text
}

/// Generates the description for the "Reset App"-Alert
/// - Returns: the alert text
func genAppResetWarning() -> String {
    return "\("general_warning_phrase".localized): \("app_reset_alert_text".localized)"
}
