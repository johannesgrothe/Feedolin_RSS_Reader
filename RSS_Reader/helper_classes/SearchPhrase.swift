//
//  SearchPhrase.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 16.12.20.
//

import Foundation

/**
 Class to implement a search prase with options to search in description or headline only, seaching for a word or a regular expression and ignoring casing
 */
class SearchPhrase {
    /** Pattern or word to search for */
    let pattern: String
    
    /** Whether the phrase is a regex or a word */
    let is_regex: Bool
    
    /** Whether the method should search the description */
    let search_description: Bool
    
    /** Whether casing sould be ignored when searching */
    let ignore_casing: Bool
    
    
    /// Constructor for the search phrase
    /// - Parameters:
    ///   - pattern: The pattern or Word to search for
    ///   - is_regex: Whether the oattern is interreted as searchphrase of regular expression
    ///   - search_description: Whether the description should be searched or not
    ///   - ignore_casing: Whether casing shpuld be ignored or not
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
    
    
    /// Method to match the SearchPhrase to an article
    /// - Parameter article: The article to search in
    /// - Returns: Whetner the Phrase was found
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
