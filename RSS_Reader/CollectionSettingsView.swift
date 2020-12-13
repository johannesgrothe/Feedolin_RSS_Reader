//
//  CollectionSettingsView.swift
//  RSS_Reader
//
//  Created by Katharina Kühn on 19.11.20.
//

import SwiftUI

/**
 Root View for the Collections settings.
 Here you see a list of all collections.
 */
struct CollectionSettingsView: View {
    var body: some View {
        CollectionSettingsList()
            .navigationBarTitle("Collection Settings")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button(action: {
                            print("Add New Collection Button clicked.")
                        }) {
                            Label("Add Collection", systemImage: "plus")
                        }
                        
                        Button(action: {
                            print("Remove Collection Button clicked.")
                        }) {
                            Label("Remove Collection", systemImage: "trash")
                        }
                    }
                    label: {
                        Label("Edit", systemImage: "square.and.pencil").imageScale(.large)
                    }
                }
            }
    }
}

/**
 A List of all collections
 */
struct CollectionSettingsList: View {

    /**
     The model
     */
    @ObservedObject var model: Model = .shared
    
    var body: some View {
        List {
            ForEach(model.collection_data) { collection in
                NavigationLink(destination: CollectionDetailSettingsView(collection: collection)) {
                    Text(collection.name).font(.headline)
                }
            }
        .listRowBackground(Color.clear)
        }
        .onAppear(perform: {
            UITableView.appearance().backgroundColor = .clear
            UITableViewCell.appearance().backgroundColor = .clear
        })
        .background(Color(UIColor(named: "BackgroundColor")!))
        .edgesIgnoringSafeArea(.bottom)
    }
}

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
     indicates if the add feed view is shown or not
     */
    @State private var show_add_feed_view = false

    /**
     * ToDo: Add comment
     */
    @State private var edit_mode = false
    
    /**
     * ToDo: Add comment
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
        .navigationBarItems(trailing:
            Button(action: {
                print("Edit collection btn clicked")
                if (edit_mode) {
                    edit_mode = false
                } else {
                    edit_mode = true
                }
                fillFeedLis()
            }) {
                if (edit_mode) {
                    Text("Done")
                } else {
                    Text("Edit")
                }
            })
        .onAppear(perform: {
            UITableView.appearance().backgroundColor = .clear
            UITableViewCell.appearance().backgroundColor = .clear
            fillFeedLis()
        })
        .background(Color(UIColor(named: "BackgroundColor")!))
        .edgesIgnoringSafeArea(.bottom)
        .navigationTitle(collection.name)
    }
    
    /**
     * ToDo: Add comments
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
