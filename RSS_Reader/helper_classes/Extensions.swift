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
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
}

