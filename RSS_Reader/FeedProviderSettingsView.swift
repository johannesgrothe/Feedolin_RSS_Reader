//
//  FeedProviderSettingsView.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 07.11.20.
//

import SwiftUI

/**
 A view to let the user edit feed provider settings
 */
struct FeedProviderSettingsView: View {
    
    let feed_provider: NewsFeedProvider
    @State private var name = ""
    @State private var short_name = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            // Dummy image for now
            feed_provider.icon.img
                .resizable()
                .frame(width: 130, height: 130)
                .padding(.horizontal, 15.0)
                .padding(.vertical, 15.0)
            
            Button(action: {
                print("change image pressed")
            }) {
                Text("Change Image")
            }
            
            HStack {
                Text("Name")
                    .padding(.horizontal, 25.0)
                TextField(
                    feed_provider.name,
                    text: $name
                ).textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 25.0)
            }
            
            HStack {
                Text("Kürzel")
                    .padding(.horizontal, 25.0)
                Spacer()
                TextField(
                    feed_provider.token,
                    text: $short_name
                ).textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 25.0)
            }
            
            Spacer()
        }
        .navigationBarTitle(feed_provider.url, displayMode: .inline)
        .navigationBarItems(
            trailing:
                Button(action: {
                    print("save_btn pressed")
                    if name != "" {
                        feed_provider.name = name
                    }
                    if short_name != "" {
                        feed_provider.token = short_name
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                }
        )
        .background(Color(UIColor(named: "BackgroundColor")!))
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct FeedProviderSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        FeedProviderSettingsView(feed_provider: NewsFeedProvider(url: "test.de", name: "TestProvider", token: "TP", icon_url: "blub/x.jpg", feeds: []))
    }
}
