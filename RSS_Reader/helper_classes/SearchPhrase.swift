//
//  SearchPhrase.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 16.12.20.
//

import Foundation

class SearchPhrase {
    let pattern: String
    let is_regex: Bool
    let search_description: Bool
    
    init(pattern: String, is_regex: Bool, search_description: Bool) {
        self.is_regex = is_regex
        self.search_description = search_description
        if is_regex {
            self.pattern = pattern
        } else {
            self.pattern = ".*?\(pattern).*?"
        }
    }
    
    func matchesArticle(_ article: ArticleData) -> Bool {
        var has_matches = !(getRegexMatches(for: pattern, in: article.title).isEmpty)
        if !has_matches && search_description {
            has_matches = !(getRegexMatches(for: pattern, in: article.description).isEmpty)
        }
        return has_matches
    }
}
