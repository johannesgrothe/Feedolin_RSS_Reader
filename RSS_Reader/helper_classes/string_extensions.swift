//
//  string_extensions.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 14.01.21.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
