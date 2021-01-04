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
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var model: Model = .shared
    
    var threading_queue = DispatchQueue(label: "rss_scan_queue", qos: .utility)
    
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
                    DetectedFeedEntry(data: feed_data)
                }
            }
            
            Spacer()
        }
    }
}

private struct DetectedFeedEntry: View {
    
    let data: NewsFeedMeta
    
    var body: some View {
        HStack {
            Text(data.title)
        }
    }
}

struct AddFeedView_Previews: PreviewProvider {
    static var previews: some View {
        AddFeedView()
    }
}
