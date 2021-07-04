//
//  Appearance.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 7/4/21.
//

import SwiftUI

/// Appearance Wrapper
enum Appearance: Int, CaseIterable, Identifiable {
    case automatic
    case light
    case dark
    
    /// for Identifiable Protocol
    var id: Int { self.rawValue }
    
    /// Strting representation
    var name: String {
        switch self {
        case .automatic: return "theme_system".localized
        case .light: return "theme_light".localized
        case .dark: return "theme_dark".localized
        }
    }
    
    /// ColorScheme
    func colorScheme() -> ColorScheme? {
        switch self {
        case .automatic: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}
