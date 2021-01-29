//
//  FeedSettingsView.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 04.11.20.
//

import SwiftUI

/**
 The View containing the navigation settings
 */
struct FeedSettingsView: View {
    /// boolean that indicates if sdd feed view is shown or not
    @State private var show_add_feed_view = false
    /// Model Singleton
    @ObservedObject var model: Model = .shared
    
    var body: some View {
        List {
            ForEach(model.feed_data) { feed_provider in
                Section(header: Text(feed_provider.name)) {
                    NavigationLink(destination: FeedProviderSettingsView(feed_provider: feed_provider)) {
                        DefaultListEntryView(
                            image: CustomImage(image: feed_provider.icon.img),
                            text: feed_provider.name,
                            font: .headline)
                    }
                    ForEach(feed_provider.feeds) { feed in
                        NavigationLink(destination: FeedEditSettingsView(feed:feed)) {
                            DefaultListEntryView(
                                sys_image: CustomSystemImage(
                                    image: .circle_small,
                                    style: .nothing,
                                    size: .xxsmall),
                                padding: ImageSize.small.size.width*0.33,
                                text: feed.name,
                                font: .subheadline)
                        }
                    }
                }
            }
            .listRowBackground(Color.clear)
        }
        .listStyle(SidebarListStyle())
        .defaultScreenLayout()
        .navigationBarTitle("Feed Settings", displayMode: .inline)
        .navigationBarItems(trailing:
                                Button(action: {
                                    self.show_add_feed_view.toggle()
                                }, label: {
                                    CustomSystemImage(image: .add)
                                })
        )
        .sheet(isPresented: self.$show_add_feed_view) {
            AddFeedView()
        }
    }
}

struct FeedSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        FeedSettingsView()
    }
}
