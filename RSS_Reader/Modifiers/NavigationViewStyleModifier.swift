//
//  NavigationViewStyleModifier.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 1/22/21.
//

import SwiftUI

/// modifier that returns diffrent navigationViewStyle based on device
struct NavigationViewStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return AnyView(content
                .navigationViewStyle(StackNavigationViewStyle()))
                .accentColor(Color.button)
        } else {
            return AnyView(content
                .navigationViewStyle(DefaultNavigationViewStyle()))
                .accentColor(Color.button)
        }
    }
}
