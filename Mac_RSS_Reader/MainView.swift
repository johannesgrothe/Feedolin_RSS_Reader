//
//  MainView.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 12/22/20.
//

import SwiftUI

/**
 View that contains the hole
 */
struct MainView: View {
    // Model Singleton
    @ObservedObject var model: Model = .shared
    
    var body: some View {
        ArticleList()
            .navigationTitle(model.filter_option.description)
            .accentColor(Color(NSColor(named: "ButtonColor")!))
            .background(Color("BackgroundColor"))
    }
}
