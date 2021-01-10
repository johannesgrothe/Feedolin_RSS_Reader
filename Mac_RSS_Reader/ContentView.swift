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
    
    @State private var show_add_feed_view = false
    
    var body: some View {
        NavigationView{
            SideMenuView()
            ArticleList()
                .toolbar{
                    ToolbarItem(placement: ToolbarItemPlacement.navigation){
                        Button(action: {
                            print("Add feed button clicked")
                            self.show_add_feed_view.toggle()
                        }) {
                            Label("Add Feed", systemImage: "plus")
                        }
                    }
                }
                .sheet(isPresented: self.$show_add_feed_view) {
                    AddFeedView()
                }
                .navigationTitle("")
                .frame(minWidth: 1000, minHeight: 700)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
