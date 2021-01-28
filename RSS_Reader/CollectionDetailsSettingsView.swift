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
     @collection is the collection that is displayed in the view
     */
    @ObservedObject var collection: Collection
    /**
     @model is the shared model singelton
     */
    @ObservedObject var model: Model = .shared
    /**
     @edit_mode is the indicator of the edit mode to  add or remove feeds
     */
    @State private var edit_mode = false
    /**
     @presented_feed_list is a list that contained all the feeds that should be shown depending on the value of edit_mode
     */
    @State private var presented_feed_list: [NewsFeed] = []
    /// IconStyle that indicates the style of every icon
    @AppStorage("image_style_int") var image_style_int: Int = ImageStyle.square_rounded.rawValue
    /// IconSize that indicates the size of every icon
    @AppStorage("image_size_int") var image_size_int: Int = ImageSize.medium.rawValue
    
    var body: some View {
        List {
            ForEach(presented_feed_list) { feed in
                // a row that contains the name of a feed, his parent token and icon
                HStack {
                    DefaultListEntryView(image: CustomImage(image: feed.parent_feed!.icon.img, style: ImageStyle.init(rawValue: image_style_int)!, size: ImageSize.init(rawValue: image_size_int)!), text: "\(feed.parent_feed!.token) - \(feed.name)", font: .headline)
                    
                    Spacer()
                    
                    if (edit_mode) {
                        let contains_feed: Bool = collection.containsFeed(feed)
                        if (contains_feed) {
                            CDButton(action: {
                                let _ = collection.removeFeed(feed)
                            }, exits: contains_feed)
                            
                        } else {
                            CDButton(action: {
                                let _ = collection.addFeed(feed)
                            }, exits: contains_feed)
                        }
                    }
                }
            }
            .listRowBackground(Color.clear)
        }
        .listStyle(PlainListStyle())
        .defaultScreenLayout()
        .navigationBarTitle(collection.name, displayMode: .inline)
        .navigationBarItems(trailing:
                                ECButton(action: {
                                    fillFeedLis()
                                }, is_editing: $edit_mode)
                            
        )
        .onAppear(perform: {
            fillFeedLis()
        })
    }
    
    /**
     * method to refresh the list of feeds, that should be displayed
     */
    func fillFeedLis() {
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
