//
//  DateFormatter_Extension.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 5/18/21.
//

import Foundation

public extension DateFormatter {
    /// custom init with dateFormat for short writing
    /// - Parameter locale: its default value is `Locale.current` so your `dateFormat` depent from this locale, if you dont want this set it to nil
    /// - Parameter dateFormat: you need to set the `dateFormat` property for custom formats
    convenience init(locale: Locale? = .current,
                     dateFormat: String)
    {
        self.init()
        if let locale = locale {
            self.locale = locale
            self.dateFormat = DateFormatter.dateFormat(fromTemplate: dateFormat, options: 0, locale: locale)
        } else {
            self.dateFormat = dateFormat
        }
    }
    /// custom init for short writing
    /// - Parameters will only set if its given, in other cases the `init()` default is used
    /// - Parameter locale: default is seit to Locale.current
    /// - Parameter relative: sets the `doesRelativeDateFormatting` property
    /// - Parameter timeStyle: sets the `timeStyle` property
    /// - Parameter dateStyle: sets the `dateStyle` property
    convenience init(locale: Locale = .current,
                     relative: Bool? = nil,
                     timeStyle: DateFormatter.Style? = nil,
                     dateStyle: DateFormatter.Style? = nil)
    {
        self.init()
        self.locale = locale
        if let relative = relative {
            self.doesRelativeDateFormatting = relative
        }
        if let timeStyle = timeStyle {
            self.timeStyle = timeStyle
        }
        if let dateStyle = dateStyle {
            self.dateStyle = dateStyle
        }
    }
}
