//
//  Date+Readable.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 4/2/21.
//

import Foundation

extension Date {
    
    private static var current_date_formatter: DateFormatter {
        let date_formatter = DateFormatter()
        date_formatter.timeZone = .current
        date_formatter.locale = .current
        return date_formatter
    }
    
    private static var long_date_formatter: DateFormatter {
        let date_formatter = current_date_formatter
        date_formatter.dateStyle = .long
        date_formatter.timeStyle = .short
        return date_formatter
    }
    
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
    
    private static var ddMMyyyyHHmm_date_formatter: DateFormatter {
        let date_formatter = current_date_formatter
        date_formatter.dateFormat = "dd-MM-yyyy HH:mm"
        return date_formatter
    }
    
    var ddMMyyyyHHmm_date: String {
        return Date.ddMMyyyyHHmm_date_formatter.string(from: self)
    }
    
    private static var EEEddMMMyyyyHHmmsszzzz_date_formatter: DateFormatter {
        let date_formatter = current_date_formatter
        date_formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss +zzzz"
        return date_formatter
    }
    
    static func EEEddMMMyyyyHHmmsszzzzDate(from string: String) -> Date? {
        return Date.EEEddMMMyyyyHHmmsszzzz_date_formatter.date(from: string)
    }
    
    private static var EEEddMMMyyyyHHmmsszzz_date_formatter: DateFormatter {
        let date_formatter = current_date_formatter
        date_formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        return date_formatter
    }
    
    static func EEEddMMMyyyyHHmmsszzzDate(from string: String) -> Date? {
        return Date.EEEddMMMyyyyHHmmsszzz_date_formatter.date(from: string)
    }
    
    private static var iso8601_date_formatter: ISO8601DateFormatter {
        let iso_date_formatter = ISO8601DateFormatter()
        iso_date_formatter.timeZone = .current
        return iso_date_formatter
    }
    
    static func iso8601Date(from string: String) -> Date? {
        return Date.iso8601_date_formatter.date(from: string)
    }
}
