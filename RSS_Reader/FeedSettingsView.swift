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
//                    NavigationLink(destination: AddFeedView()) {
//                        Image(systemName: "plus").imageScale(.large)
//                    }
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
                print("Adding Feed:")
                print(text)
                addFeed(url: text)
                self.presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .cornerRadius(8)
            Spacer()
        }
    }
    
    func addFeed(url: String) {
        let parser = FeedParser()
        if parser.fetchData(url: url) {
            let parsed_feed_info = parser.parseData()
            if parsed_feed_info != nil {
                let feed_meta = parsed_feed_info!.feed_info
                
                var parent_feed = model.getFeedProviderForURL(feed_meta.main_url)
                
                if parent_feed == nil {
                    parent_feed = NewsFeedProvider(web_protocol: feed_meta.url_protocol, url: feed_meta.main_url, name: feed_meta.main_url, token: feed_meta.main_url, icon: NewsFeedIcon(url: ""), feeds: [])
                    model.feed_data.append(parent_feed!)
                }
                
                let sub_feed = NewsFeed(url: feed_meta.sub_url, name: feed_meta.title, show_in_main: true, use_filters: false, image: nil)
                
                let add_successful = parent_feed!.addFeed(feed: sub_feed)
                
                if !add_successful {
                    print("Feed with url '\(feed_meta.main_url)'/'\(feed_meta.sub_url)' altready exists")
                    return
                }
                
                var new_article_data: [ArticleData] = []
                
                for article in parsed_feed_info!.articles {
                    new_article_data.append(ArticleData(article_id: article.article_id, title: article.title, description: article.description, link: article.link, pub_date: article.pub_date, author: article.author, parent_feed: sub_feed))
                }
                
                let added_feeds = model.addArticles(new_article_data)
                
                print("Added \(added_feeds) of \(parsed_feed_info!.articles.count) feeds to \(parent_feed!.url)/\(sub_feed.url)")
                
            } else {
                print("Parsing Feed failed")
            }
        } else {
            print("Loading data from URL failed")
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
