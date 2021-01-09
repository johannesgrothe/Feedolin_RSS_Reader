//
//  ContentView.swift
//  RSS_Reader
//
//  Created by Emircan Duman on 29.10.20.
//

import SwiftUI
import CoreData

/**
 First Screen of the App
 */
struct ContentView: View {
    
    // Model Singleton
    @ObservedObject var model: Model = .shared
    
    var body: some View {
        NavigationView{
            SideMenuView()
            ArticleList()
        }
        .navigationTitle("")
        .frame(minWidth: 1000, minHeight: 700)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
