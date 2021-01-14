//
//  Extensions.swift
//  RSS_Reader
//
//  Created by Katharina Kühn on 02.01.21.
//

import Foundation

/**
 * extends the String class to check, if the string contains only numbers or letters (a-z, 0-9)
 */
extension String {
    
    /// Whether the string only consists of alphanumeric characters or not
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    /// Removes a certain amount of characters from the beginning of the string
    /// - Parameter count: amount of characters that should be removed
    /// - Returns: The modified string
    func chopPrefix(_ count: UInt = 1) -> String {
        return substring(from: self.index(startIndex, offsetBy: Int(count)))
    }

    /// Removes a certain amount of characters from the end of the string
    /// - Parameter count: amount of characters that should be removed
    /// - Returns: The modified string
    func chopSuffix(_ count: UInt = 1) -> String {
        return substring(to: self.index(endIndex, offsetBy: -Int(count)))
    }
}

