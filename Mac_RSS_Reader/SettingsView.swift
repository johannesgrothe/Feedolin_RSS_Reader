//
//  SettingsView.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 04.11.20.
//

import SwiftUI

struct SettingsView: View {
    /**Model singleton*/
    @ObservedObject var model: Model = .shared
    
    @State private var showingAlert = false
    
    private enum Tabs: Hashable {
        case feed_provider, collection, general
    }
    
    var body: some View {
        
        TabView {
            GeneralSettingsView()
                .tabItem{
                    Label("General Settings", systemImage: "gear")
                }
                .tag(Tabs.general)
            
            FeedSettingsView()
                .tabItem {
                    Label("Feed Settings", systemImage: "newspaper")
                }
                .tag(Tabs.feed_provider)
                
            CollectionSettingsView()
                .tabItem{
                    Label("Collection Settings", systemImage: "folder.badge.gear")
                }
                .tag(Tabs.collection)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
