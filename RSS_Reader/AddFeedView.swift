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
    @State private var text = ""
    @State private var loading = false
    
    @State private var entered_main_url = ""
    @State private var detected_feeds: [NewsFeedMeta] = []
    @State private var is_scanning: Bool = false
    private var detection_thread: DispatchWorkItem? = nil
    
    @State private var refresh_view: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var model: Model = .shared
    
    /**
     @showingAlert shows if alert is true*/
    @State private var showing_alert = false
    
    var body: some View {
        VStack {
            Text("Add Feed").padding(.top, 10)
            HStack {
                TextField(
                    "Enter URL",
                    text: $text
                ).textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 25.0)
                .onChange(of: text) { newValue in
                    let buf_main_url = detectURL(text)
                    if buf_main_url != nil && buf_main_url != entered_main_url {
                        print("New URL detected: \(buf_main_url!)")
                        
                        DispatchQueue.global().async {
                            is_scanning = true
                            detected_feeds = detectFeeds(buf_main_url!, shallow_scan: true)
                            is_scanning = false
                        }
                        print("Searching finished")
                    }
                }
                if is_scanning {
                    ProgressView()
                    .padding(.trailing, 25.0)
                }
            }
            Button("Add Feed") {
                loading = true
                let _ = model.addFeed(url: text)
                loading = false
                self.presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .cornerRadius(8)
            .accentColor(Color(UIColor(named: "ButtonColor")!))
            
            /** All of the detected feeds */
            List {
                ForEach(detected_feeds) { feed_data in
                    HStack {
                        let feed_in_model = model.getFeedByURL(feed_data.complete_url)
                        if feed_in_model != nil {
                            Text(feed_in_model!.name)
                            Spacer()
                            Button(action: {
                                print("Remove Detected Feed Button clicked.")
                                self.showing_alert = true
//                                model.removeFeed(feed_in_model!)
                                refresh_view = !refresh_view
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                            }
                            .alert(isPresented: $showing_alert) {
                                Alert(title: Text("Removing Feed"), message: Text(getWaringTextForFeedRemoval(feed_in_model!)), primaryButton: .default(Text("Okay"), action: {
                                        model.removeFeed(feed_in_model!)
                                }),secondaryButton: .cancel())
                            }
                            
                            .buttonStyle(BorderlessButtonStyle())
                        } else {
                            Text(feed_data.title)
                            Spacer()
                            Button(action: {
                                print("Add Detected Feed Button clicked.")
                                _ = model.addFeed(feed_meta: feed_data)
                                refresh_view = !refresh_view
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.green)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                }
            }
            .listRowBackground(Color.clear)
            
            Spacer()
        }
    }
}

private struct DetectedFeedEntry: View {
    
    let data: NewsFeedMeta
    
    var body: some View {
        HStack {
            Text(data.title)
            // Send Button for new collection
            Button(action: {
                print("Add Detected Feed Button clicked.")
            }) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.green)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }
}

struct AddFeedView_Previews: PreviewProvider {
    static var previews: some View {
        AddFeedView()
    }
}
