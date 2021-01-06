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
     * indicates if the user is in edit_mode to add or remove feeds
     */
    @State private var edit_mode = false
    
    /**
     * a list contained all the feeds that should be shown depending on the value of edit_mode
     */
    @State private var presented_feed_list: [NewsFeed] = []
    
    var body: some View {
        List {
            ForEach(presented_feed_list) { feed in
                // a row that contains the name of a feed, his parent token and icon
                HStack {
                    
                    feed.parent_feed!.icon.img
                        .resizable()
                        .frame(width: 25, height: 25)
                    Text("\(feed.parent_feed!.token) - \(feed.name)")
                    Spacer()
                    
                    if (edit_mode) {
                        
                        if (collection.containsFeed(feed)) {
                           
                            Button(action: {
                                print("Delete Feed from Collection Button clicked.")
                                let _ = collection.removeFeed(feed)
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                            }
                        } else {
                            Button(action: {
                                print("Add Feed to Collection Button clicked.")
                                let _ = collection.addFeed(feed)
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                            
                            
                    }
                    
                }
            }
            .listRowBackground(Color.clear)
        }
//        .navigationBarItems(trailing:
//            Button(action: {
//                print("Edit collection btn clicked")
//                if (edit_mode) {
//                    edit_mode = false
//                } else {
//                    edit_mode = true
//                }
//                fillFeedLis()
//            }) {
//                if (edit_mode) {
//                    Text("Done")
//                } else {
//                    Text("Edit")
//                }
//            })
//        .onAppear(perform: {
//            UITableView.appearance().backgroundColor = .clear
//            UITableViewCell.appearance().backgroundColor = .clear
//            fillFeedLis()
//        })
        .background(Color("BackgroundColor"))
        .navigationTitle(collection.name)
    }
    
    /**
     * method to refresh the list of feeds, that should be displayed
     */
    func fillFeedLis() {
        print("call fill feed list")
        if (edit_mode) {
            self.presented_feed_list = []
            for feed_prov in model.feed_data {
                for feed in feed_prov.feeds {
                    self.presented_feed_list.append(feed)
                }
            }
        } else {
            self.presented_feed_list = collection.feed_list
        }
        
        self.presented_feed_list.sort {
            if $0.parent_feed!.token == $1.parent_feed!.token {
                return $0.name < $1.name
            }
            return $0.parent_feed!.token < $1.parent_feed!.token
        }
        
    }
}
