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
    
    /// IconStyle that indicates the style of every icon
    @AppStorage("image_style_int") var image_style_int: Int = ImageStyle.square_rounded.rawValue
    /// IconSize that indicates the size of every icon
    @AppStorage("image_size_int") var image_size_int: Int = IconSize.medium.rawValue
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        CustomIcon(icon: .close, style: ImageStyle.init(rawValue: image_style_int)!, size: IconSize.init(rawValue: image_size_int)!)
                    })
                    Spacer()
                    Text("Add Feeds")
                        .font(.headline)
                    Spacer()
                    Button(action: {
                        detector.detect(text, deep_scan: true)
                    },label: {
                        CustomIcon(icon: .search, style: ImageStyle.init(rawValue: image_style_int)!, size: IconSize.init(rawValue: image_size_int)!)
                    })
                }
                HStack {
                    HStack {
                        TextField(
                            "url_textfield".localized,
                            text: $text
                        )
                        
                        // x Button
                        Button(action: {
                            text = ""
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                                .opacity(text == "" ? 0 : 1)
                        })
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
            }
            .padding()
            .background(Color(UIColor(named: "TopbarColor")!))
            
            /** All of the detected feeds */
            List {
                if (detector.specific_feed != nil) {
                    Section(header: Text("Feed found in link:")) {
                        DetectedFeedEntry(feed_data: detector.specific_feed!)
                    }
                    .listRowBackground(Color.clear)
                }
                
                if !detector.detected_feeds.isEmpty {
                    Section(header: Text("Feed found in website:")) {
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
        .background(Color("BackgroundColor"))
        .accentColor(Color("ButtonColor"))
        .edgesIgnoringSafeArea(.bottom)
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
                    CustomIcon(icon: .minus, style: .nothing, size: .small, color: .red)
                }
                .alert(isPresented: $showing_alert) {
                    Alert(title: Text("feed_delete_alert_title".localized), message: Text(getWaringTextForFeedRemoval(detected_feed!)), primaryButton: .default(Text("ok_btn_title".localized), action: {
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
                    CustomIcon(icon: .plus, style: .nothing, size: .small, color: .green)
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
