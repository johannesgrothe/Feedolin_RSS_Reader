//
//  AddFeedView.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 04.01.21.
//

import SwiftUI

/**
 The view that lets you type in an url and add it to the feeds
 */
struct AddFeedView: View {
    
    /** Buffer for the textfield */
    @State private var text = ""
    
    /** Little hack to refresh the view: set it to !refresh_view to trigger refresh */
    @State private var refresh_view: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    /** Model of the app */
    @ObservedObject var model: Model = .shared
    
    @ObservedObject var detector = FeedDetector()
    
    /** Buffer for the feed that should be removed: Alert does not capture the correct feed, so it needs to be stored somewhere */
    @State var remove_feed: NewsFeed? = nil
    
    /**
     @showingAlert shows if alert is true*/
    @State private var showing_alert = false
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Button("Close") { self.presentationMode.wrappedValue.dismiss() }
                        .padding(.horizontal, 20)
                    Spacer()
                    Text("Add Feeds")
                    Spacer()
                    Button("Scan") { self.presentationMode.wrappedValue.dismiss() }
                        .padding(.horizontal, 20)
                }
                HStack {
                    TextField(
                        "Enter URL",
                        text: $text
                    )
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 25.0)
                    .onChange(of: text) { newValue in
                        detector.detect(text)
                    }
                    if detector.is_scanning {
                        ProgressView()
                        .padding(.trailing, 25.0)
                    }
                }
            }
            .padding()
            .background(Color(UIColor(named: "TopbarColor")!))
            
            /** All of the detected feeds */
            List {
                if (detector.specific_feed != nil) {
                    Section(header: Text("Feed found in link:")) {
                        DetectedFeedEntry(feed_data: detector.specific_feed!)
                    }
                    .background(Color.clear)
                }
                if !detector.detected_feeds.isEmpty {
                    Section(header: Text("Feed found in website:")) {
                        ForEach(detector.detected_feeds) { feed_data in
                            DetectedFeedEntry(feed_data: feed_data)
                        }
                    }
                    .background(Color.clear)
                }
            }
            .listRowBackground(Color.clear)
            
            Spacer()
        }
    }
}

struct DetectedFeedEntry: View {
    let feed_data: NewsFeedMeta
    @State var remove_feed: NewsFeed?
    @State var showing_alert: Bool = false
    
    var body: some View {
        HStack {
            let feed_in_model = model.getFeedByURL(feed_data.complete_url)
            if feed_in_model != nil {
                Text(feed_in_model!.name)
                Spacer()
                Button(action: {
                    print("Remove Detected Feed Button clicked.")
                    self.showing_alert = true
                    remove_feed = feed_in_model
                }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                }
                .alert(isPresented: $showing_alert) {
                    Alert(title: Text("Removing Feed"), message: Text(getWaringTextForFeedRemoval(remove_feed!)), primaryButton: .default(Text("Okay"), action: {
                            model.removeFeed(remove_feed!)
                    }),secondaryButton: .cancel())
                }
                
                .buttonStyle(BorderlessButtonStyle())
            } else {
                Text(feed_data.title)
                Spacer()
                Button(action: {
                    print("Add Detected Feed Button clicked.")
                    _ = model.addFeed(feed_meta: feed_data)
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.green)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
    }
}

struct AddFeedView_Previews: PreviewProvider {
    static var previews: some View {
        AddFeedView()
    }
}
