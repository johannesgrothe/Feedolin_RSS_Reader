//
//  ImageStyleModifier.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 1/28/21.
//

import SwiftUI

/// modifier that returns diffrent navigationViewStyle based on device
struct ImageStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return AnyView(content
                .navigationViewStyle(StackNavigationViewStyle()))
                .accentColor(Color("ButtonColor"))
        } else {
            return AnyView(content
                .navigationViewStyle(DefaultNavigationViewStyle()))
                .accentColor(Color("ButtonColor"))
        }
    }
}
