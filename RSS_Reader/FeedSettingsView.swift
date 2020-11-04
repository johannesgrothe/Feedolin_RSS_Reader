//
//  FeedSettingsView.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 04.11.20.
//

import SwiftUI

struct FeedSettingsView: View {
    var body: some View {
        FeedSettingsList()
            .navigationTitle("Feed Settings")
            .navigationBarItems(
                trailing:
                    NavigationLink(destination: AddFeedView()) {
                        Image(systemName: "plus").imageScale(.large)
                    }
            )
    }
}


struct AddFeedView: View {
    @State private var text = ""
    
    var body: some View {
        VStack {
            TextField(
                "enter url",
                text: $text
            ).textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Add Feed") {
                print("Adding Feed:")
                print(text)
                addFeed(url: text)
            }
//                .foregroundColor(.white)
                .padding()
//                .background(Color.accentColor)
                .cornerRadius(8)
        }
    }
    
    func addFeed(url: String) {
        let parser = FeedParser()
        if parser.fetchData(url: url) {
            if parser.parseData() {
                let parsed_feed_info = parser.getParsedData()
                if parsed_feed_info != nil {
                    print("Yayyyy")
                    
                    let blub1 = NewsFeedProvider(url: parsed_feed_info!.feed_info.main_url, name: parsed_feed_info!.feed_info.main_url, token: "", icon: NewsFeedIcon(url: "blub.de/x.png"), feeds: [NewsFeed(url: parsed_feed_info!.feed_info.sub_url, name: parsed_feed_info!.feed_info.title, show_in_main: true, use_filters: true, image: nil)])
                    model.feed_data.append(blub1)
                    
                    print("Adding \(parsed_feed_info!.articles.endIndex) Articles to collection")
                    for feed in parsed_feed_info!.articles {
                        model.addArticle(feed)
                    }
                    
                } else {
                    print("Parsing failed... somehow??")
                }
            } else {
                print("Parsing failed")
            }
        } else {
            print("Fetching URL failed")
        }
    }
}


struct FeedSettingsList: View {
    var body: some View {
        List(model.feed_data) {
            dataSet in FeedProviderSettingsListView(feed_provider: dataSet)
        }
    }
}


struct FeedProviderSettingsListView: View {
    
    let feed_provider: NewsFeedProvider
    
    var body: some View {
        
        VStack {
            NavigationLink(destination: DummyDetailView()) {
                HStack {
                    Image(systemName: "person").imageScale(.large)
                    Text(feed_provider.name).font(.headline)
                }
            }
            List(feed_provider.feeds) {
                feed_data in NavigationLink(destination: DummyDetailView()) {
                    Text(feed_data.name)
                }
            }
        }
    }
}


struct FeedSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        FeedSettingsView()
    }
}
