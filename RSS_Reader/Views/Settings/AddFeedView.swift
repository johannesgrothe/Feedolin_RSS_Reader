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
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                        detector.detect("")
                    }, label: {
                        CustomSystemImage(image: .close, size: .medium)
                    })
                    Spacer()
                    Text("add_feed_title".localized)
                        .font(.headline)
                    Spacer()
                    Button(action: {
                        detector.detect(text, deep_scan: true)
                    },label: {
                        CustomSystemImage(image: .search, size: .medium)
                    })
                }
                HStack {
                    CustomTextfield(placholder: "url_textfield".localized,
                                    text: $text,
                                    on_commit: {
                                        detector.detect(text)
                                    })
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
            .background(Color.topbar)
            
            /** All of the detected feeds */
            List {
                if (detector.specific_feed != nil) {
                    Section(header: Text("found_in_website_section_title".localized)) {
                        DetectedFeedEntry(feed_data: detector.specific_feed!)
                    }
                    .listRowBackground(Color.clear)
                }
                
                if !detector.detected_feeds.isEmpty {
                    Section(header: Text("found_in_url_section_title".localized)) {
                        ForEach(detector.detected_feeds) { feed_data in
                            DetectedFeedEntry(feed_data: feed_data)
                        }
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(PlainListStyle())
            
            Spacer()
        }
        .defaultScreenLayout()
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
                CDButton(action: {
                    print("Remove Detected Feed Button clicked.")
                    self.showing_alert = true
                    detected_feed = feed_in_model
                }, exits: true)
                .alert(isPresented: $showing_alert) {
                    Alert(title: Text("feed_delete_alert_title".localized), message: Text(getWaringTextForFeedRemoval(detected_feed!)), primaryButton: .default(Text("ok_btn_title".localized), action: {
                            //model.removeFeed(detected_feed!)
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
                CDButton(action: {
                    print("Add Detected Feed Button clicked.")
                    _ = model.addFeed(feed_meta: feed_data)
                }, exits: false)
            }
        }
    }
}

struct AddFeedView_Previews: PreviewProvider {
    static var previews: some View {
        AddFeedView()
    }
}
