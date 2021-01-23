//
//  DefaultSreenLayoutModifier.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 1/23/21.
//

import SwiftUI

/// modifier that returns default screen settings
struct DefaultScreenLayoutModifier: ViewModifier {
    func body(content: Content) -> some View {
        return AnyView(content
                        .background(Color("BackgroundColor"))
                        .accentColor(Color("ButtonColor"))
                        .edgesIgnoringSafeArea(.bottom))
    }
}
