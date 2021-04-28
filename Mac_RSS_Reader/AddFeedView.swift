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
    
    @Environment(\.presentationMode) var presentationMode
    
    /** Model of the app */
    @ObservedObject var model: Model = .shared
    
    @ObservedObject var detector: FeedDetector = .shared
    
    /** Buffer for the feed that should be removed: Alert does not capture the correct feed, so it needs to be stored somewhere */
    @State var remove_feed: NewsFeed? = nil
    
    /**
     @showingAlert shows if alert is true*/
    @State private var showing_alert = false
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    HStack {
                        TextField(
                            "Enter URL",
                            text: $text
                        )
                        Spacer()
                        
                        // x Button
                        Button(action: {
                            print("Clear search bar button clicked.")
                            text = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                                .opacity(text == "" ? 0 : 1)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
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
                
                HStack {
                    Button("Close") { self.presentationMode.wrappedValue.dismiss() }
                        .buttonStyle(BorderlessButtonStyle())
                    Spacer()
                    Button("Scan") { detector.detect(text, deep_scan: true) }
                        .buttonStyle(BorderlessButtonStyle())
                }
            }
            .padding()
            
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
        .frame(idealWidth: 300, idealHeight: 450)
    }
}

/// A View to display a feed in the list above
struct DetectedFeedEntry: View {
    /** feed data to display */
    let feed_data: NewsFeedMeta
    
    /** Feed detected in the model */
    @State var detected_feed: NewsFeed?
    
    /** Variable to show the 'remove feed'-alert */
    @State var showing_alert: Bool = false
    
    /** Model of the app */
    @ObservedObject var model: Model = .shared
    
    var body: some View {
        HStack {
            let feed_in_model = model.getFeedByURL(feed_data.complete_url)
            if feed_in_model != nil {
                /** Code to display when feed is already found in model */
                VStack(alignment: .leading) {
                    Text(feed_data.complete_url)
                        .font(.system(size: 10))
                    Text(feed_in_model!.name)
                }
                Spacer()
                Button(action: {
                    print("Remove Detected Feed Button clicked.")
                    self.showing_alert = true
                    detected_feed = feed_in_model
                }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                }
                .alert(isPresented: $showing_alert) {
                    Alert(title: Text("Removing Feed"), message: Text(getWaringTextForFeedRemoval(detected_feed!)), primaryButton: .default(Text("Okay"), action: {
                            model.removeFeed(detected_feed!)
                    }),secondaryButton: .cancel())
                }
                .buttonStyle(BorderlessButtonStyle())
            } else {
                /** Code to display if no feed was found in model */
                VStack(alignment: .leading) {
                    Text(feed_data.complete_url)
                        .font(.system(size: 10))
                    Text(feed_data.title)
                }
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
