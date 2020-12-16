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
    let ignore_casing: Bool
    
    init(pattern: String, is_regex: Bool, search_description: Bool, ignore_casing: Bool) {
        self.is_regex = is_regex
        self.search_description = search_description
        self.ignore_casing = ignore_casing
        
        if is_regex {
            self.pattern = pattern
        } else {
            /** Save pattern */
            var buf_pattern = pattern
            
            /** Replace saved pattern with lowercased one if casing should be ignored */
            if ignore_casing {
                buf_pattern = pattern.lowercased()
            }
            
            self.pattern = ".*?\(buf_pattern).*?"
        }
    }
    
    func matchesArticle(_ article: ArticleData) -> Bool {
        var buf_title = article.title
        var buf_desc = article.description
        
        if ignore_casing {
            buf_title = buf_title.lowercased()
            buf_desc = buf_desc.lowercased()
        }
        
        var has_matches = !(getRegexMatches(for: pattern, in: buf_title).isEmpty)
        if !has_matches && search_description {
            has_matches = !(getRegexMatches(for: pattern, in: buf_desc).isEmpty)
        }
        return has_matches
    }
}
