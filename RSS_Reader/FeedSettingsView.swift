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
    
    @State private var show_add_feed_view = false
    
    var body: some View {
        FeedSettingsList()
            .navigationTitle("Feed Settings")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button(action: {
                            print("Add feed button clicked")
                            self.show_add_feed_view.toggle()
                        }) {
                            Label("Add Feed", systemImage: "plus")
                        }
                        
                        Button(action: {
                            print("Remove feed button clicked")
                        }) {
                            Label("Remove feed", systemImage: "trash")
                        }
                    }
                    label: {
                        Label("Edit", systemImage: "square.and.pencil").imageScale(.large)
                    }
                }
            }.sheet(isPresented: self.$show_add_feed_view) {
                AddFeedView()
            }
    }
}

/**
 The view that lets you type in an url and add it to the feeds
 */
struct AddFeedView: View {
    @State private var text = ""
    @State private var loading = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var model: Model = .shared
    
    var body: some View {
        ZStack {
            VStack {
                Text("Add Feed").padding(.top, 10)
                TextField(
                    "Enter URL",
                    text: $text
                ).textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 25.0)
                Button("Add Feed") {
                    loading = true
                    let _ = model.addFeed(url: text)
                    loading = false
                    self.presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .cornerRadius(8)
                .accentColor(Color(UIColor(named: "ButtonColor")!))
                Spacer()
            }.disabled(self.loading)
            .blur(radius: self.loading ? 3 : 0)
            .background(Color(UIColor(named: "BackgroundColor")!))
            .edgesIgnoringSafeArea(.bottom)
            VStack {
                Text("Loading...")
                ProgressView()
            }.disabled(self.loading)
            .opacity(self.loading ? 1 : 0)
        }
        
    }
    
}

/**
 View that presents all of the feeds and feed providers
 */
struct FeedSettingsList: View {
    
    @ObservedObject var model: Model = .shared
    
    var body: some View {
        List {
            ForEach(model.feed_data) { feed_provider in
                FeedProviderSettingListEntry(feed_provider: feed_provider)
                ForEach(feed_provider.feeds) { feed in
                    FeedSettingsListEntry(feed_article: feed)
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
 View that presents a feed provider list entry for the settings menu
 */
struct FeedProviderSettingListEntry: View {
    
    // Needs to be observed object to be propperly refreshed once changed
    @ObservedObject var feed_provider: NewsFeedProvider
    
    var body: some View {
        NavigationLink(destination: FeedProviderSettingsView(feed_provider: feed_provider)) {
            HStack {
                (feed_provider.icon.img)
                    .resizable()
                    .frame(width: 25, height: 25)
                Text(feed_provider.name).font(.headline)
            }
        }
    }
}

/**
 View that presents a feed list entry for the settings menu
 */
struct FeedSettingsListEntry: View {
    
    @ObservedObject var feed_article: NewsFeed
    
    var body: some View {
        NavigationLink(destination: FeedEditSettingsView(feed:feed_article)) {
            HStack {
                Image(systemName: "smiley").imageScale(.large)
                Text(feed_article.name)
            }
        }
    }
}


struct FeedSettingsView_Previews: PreviewProvider {
    
    static var previews: some View {
        FeedSettingsView()
    }
}
