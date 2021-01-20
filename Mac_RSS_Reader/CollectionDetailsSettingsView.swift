//
//  CollectionSettingsView.swift
//  RSS_Reader
//
//  Created by Katharina Kühn on 19.11.20.
//

import SwiftUI

/**
 The detailed view of a specific collection
 Here you see a list of feeds contained in this collection
 */
struct CollectionDetailSettingsView: View {
    
    /**
     * The collection that is displayed in the view
     */
    @ObservedObject var collection: Collection
    
    /**
     * Model Singleton
     */
    @ObservedObject var model: Model = .shared
    
    /**
     * a list contained all the feeds that should be shown depending on the value of edit_mode
     */
    @State private var presented_feed_list: [NewsFeed] = []
    
    var body: some View {
        Form{
            List {
                ForEach(presented_feed_list) { feed in
                    // a row that contains the name of a feed, his parent token and icon
                    CollectionToggleView(feed: feed, collection: collection, check: collection.containsFeed(feed))
                        .padding(.horizontal)
                }
            }
            .onAppear(perform: {
                fillFeedLis()
            })
        }
    }
    
    /**
     * method to refresh the list of feeds, that should be displayed
     */
    func fillFeedLis() {
        print("call fill feed list")
        self.presented_feed_list = []
        for feed_prov in model.feed_data {
            for feed in feed_prov.feeds {
                self.presented_feed_list.append(feed)
            }
        }
        
        self.presented_feed_list.sort {
            if $0.parent_feed!.token == $1.parent_feed!.token {
                return $0.name < $1.name
            }
            return $0.parent_feed!.token < $1.parent_feed!.token
        }
    }
}

struct CollectionToggleView: View{
    @ObservedObject var feed: NewsFeed
    @ObservedObject var collection: Collection
    @State var check: Bool
    
    var body: some View{
        
        HStack {
            feed.parent_feed!.icon.img
                .resizable()
                .frame(width: 25, height: 25)
            Text("\(feed.parent_feed!.token) - \(feed.name)")
            Toggle(isOn: $check){
                
            }
            .onChange(of: check, perform: { value in
                if value{
                    let _ = collection.addFeed(feed)
                }
                else{
                    let _ = collection.removeFeed(feed)
                }
            })
            .toggleStyle(CheckboxToggleStyle())
            
            Spacer()
        }
        .frame(minWidth: 250, idealWidth: 350)
        .lineLimit(1)
    }
}
