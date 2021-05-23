//
//  Date_Extension.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 4/2/21.
//

import Foundation

extension Date {
    
    private static var long_date_short_time_formatter: DateFormatter = DateFormatter(timeStyle: .short, dateStyle: .long)
    
    var long_date_short_time: String {
        return Date.long_date_short_time_formatter.string(from: self)
    }
    
    private static var relativ_short_date_formatter: RelativeDateTimeFormatter {
        let date_formatter = RelativeDateTimeFormatter()
        date_formatter.unitsStyle = .short
        date_formatter.locale = .current
        return date_formatter
    }
    
    var relative_short_date: String {
        return Date.relativ_short_date_formatter.localizedString(for: self, relativeTo: Date())
    }
    
    /// parsing rss feed pubdate
    private static var rfc_822_format: DateFormatter = DateFormatter(locale: Locale(identifier: "en_US_POSIX"), dateFormat: "E, d MMM yyyy HH:mm:ss Z", localDependingDateFormat: false)
    
    static func rfc822Date(from string: String) -> Date? {
        return Date.rfc_822_format.date(from: string)
    }
    
    /// parsing rss feed pubdate
    private static var iso8601_date_formatter: ISO8601DateFormatter = ISO8601DateFormatter()
    
    static func iso8601Date(from string: String) -> Date? {
        return Date.iso8601_date_formatter.date(from: string)
    }
}
