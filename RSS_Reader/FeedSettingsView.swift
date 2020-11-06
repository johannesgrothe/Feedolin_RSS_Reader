//
//  FeedSettingsView.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 04.11.20.
//

import SwiftUI

struct FeedSettingsView: View {
    
    @State private var show_add_feed_view = false
    
    var body: some View {
        FeedSettingsList()
            .navigationTitle("Feed Settings")
            .navigationBarItems(
                trailing:
                    Button(action: {
                        self.show_add_feed_view.toggle()
                    }) {
                        Image(systemName: "plus").imageScale(.large)
                    }.sheet(isPresented: $show_add_feed_view) {
                        AddFeedView()
                    }
            )
    }
}


struct AddFeedView: View {
    @State private var text = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Add Feed").padding(.top, 10)
            TextField(
                "Enter URL",
                text: $text
            ).textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal, 25.0)
            Button("Add Feed") {
                model.addFeed(url: text)
                self.presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .cornerRadius(8)
            Spacer()
        }
    }
}


struct FeedSettingsList: View {
    var body: some View {
        List {
            ForEach(model.feed_data) { feed_provider in
                FeedProviderSettingListEntry(feed_provider: feed_provider)
                ForEach(feed_provider.feeds) { feed in
                    FeedSettingsListEntry(feed: feed)
                }
          }
        }
    }
}


struct FeedProviderSettingListEntry: View {
    
    let feed_provider: NewsFeedProvider
    
    var body: some View {
        NavigationLink(destination: DummyDetailView()) {
            HStack {
                Image(systemName: "person").imageScale(.large)
                Text(feed_provider.name).font(.headline)
            }
        }
    }
}


struct FeedSettingsListEntry: View {
    
    let feed: NewsFeed
    
    var body: some View {
        NavigationLink(destination: DummyDetailView()) {
            HStack {
                Image(systemName: "smiley").imageScale(.large)
                Text(feed.name)
            }
        }
    }
}


struct FeedSettingsView_Previews: PreviewProvider {
    
    static var previews: some View {
        FeedSettingsView()
    }
}
