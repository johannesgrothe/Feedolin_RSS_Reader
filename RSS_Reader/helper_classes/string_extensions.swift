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

func genAppResetWarning() -> String {
    return "app_reset_alert_text".localized
}
