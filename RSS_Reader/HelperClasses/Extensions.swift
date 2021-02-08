//
//  Extensions.swift
//  RSS_Reader
//
//  Created by Katharina Kühn on 02.01.21.
//

import Foundation
import SwiftUI
/**
 * extends the String class to check, if the string contains only numbers or letters (a-z, 0-9)
 */
extension String {
    
    /// Whether the string only consists of alphanumeric characters or not
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    /// Uses the string as key and returns the localized version of it
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    /// Removes a certain amount of characters from the beginning of the string
    /// - Parameter count: amount of characters that should be removed
    /// - Returns: The modified string
    func chopPrefix(_ count: UInt = 1) -> String {
        let start_bound = String.Index(utf16Offset: Int(count), in: self)
        let final_str = String(self[start_bound..<self.endIndex])
        return final_str
    }
}
/// extends NavigationView
extension NavigationView {
    
    /// defines the NavigationViewStyle with that modifier
    /// - Returns: changed NavigationView
    func autoNavigationViewStyle() -> some View {
        self.modifier(NavigationViewStyleModifier())
    }
}

/// extends View
extension View {
    
    /// defines the default ScreenLayout
    /// - Returns: the changed
    func defaultScreenLayout() -> some View {
        self.modifier(DefaultScreenLayoutModifier())
    }
}


/// UINavigationController for the overall UINavigationBarAppearance
extension UINavigationController {
    /// Add the TobarColor tto all Navigationbars
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "TopbarColor")!
        navigationBar.standardAppearance = appearance
    }
}

/// extension color for custom colors
extension Color {
    /// article color
    public static var article: Color {
        return Color("ArticleColor")
    }
    /// topbar color
    public static var topbar: Color {
        return Color("TopbarColor")
    }
    /// background color
    public static var background: Color {
        return Color("BackgroundColor")
    }
    /// button color
    public static var button: Color {
        return Color("ButtonColor")
    }

}
