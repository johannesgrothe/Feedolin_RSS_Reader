//
//  Date_Extension.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 4/2/21.
//

import Foundation

extension Date {
    
    private static var long_date_formatter: DateFormatter = DateFormatter(timeStyle: .short, dateStyle: .long)
    
    var long_date: String {
        return Date.long_date_formatter.string(from: self)
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
    
    private static var ddMMyyyyHHmm_date_formatter: DateFormatter = DateFormatter(dateFormat: "dd-MM-yyyy HH:mm")
    
    var ddMMyyyyHHmm_date: String {
        return Date.ddMMyyyyHHmm_date_formatter.string(from: self)
    }
    
    /// parsing rss feed pubdate
    private static var EEEddMMMyyyyHHmmsszzzz_date_formatter: DateFormatter = DateFormatter(locale: Locale(identifier: "GMT") ,dateFormat: "EEE, dd MMM yyyy HH:mm:ss +zzzz")
    
    static func EEEddMMMyyyyHHmmsszzzzDate(from string: String) -> Date? {
        return Date.EEEddMMMyyyyHHmmsszzzz_date_formatter.date(from: string)
    }
    
    /// parsing rss feed pubdate
    private static var EEEddMMMyyyyHHmmsszzz_date_formatter: DateFormatter = DateFormatter(locale: Locale(identifier: "GMT"), dateFormat: "EEE, dd MMM yyyy HH:mm:ss zzz")
    
    static func EEEddMMMyyyyHHmmsszzzDate(from string: String) -> Date? {
        return Date.EEEddMMMyyyyHHmmsszzz_date_formatter.date(from: string)
    }
    
    /// parsing rss feed pubdate
    private static var iso8601_date_formatter: ISO8601DateFormatter {
        let iso_date_formatter = ISO8601DateFormatter()
        iso_date_formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return iso_date_formatter
    }
    
    static func iso8601Date(from string: String) -> Date? {
        return Date.iso8601_date_formatter.date(from: string)
    }

    /// parsing rss feed pubdate
    private static var full_date_formatter: DateFormatter = DateFormatter(locale: Locale(identifier: "GMT"),timeStyle: .full, dateStyle: .full)

    static func fullDate(from string: String) -> Date? {
        return Date.full_date_formatter.date(from: string)
    }
}
