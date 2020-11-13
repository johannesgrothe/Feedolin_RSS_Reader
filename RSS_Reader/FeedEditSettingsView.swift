//
//  FeedEditSettingsView.swift
//  RSS_Reader
//
//  Created by Emircan Duman on 10.11.20.
//

import SwiftUI

/**
 A view to let the user edit feed articles settings
 */
struct FeedEditSettingsView: View {
    
    let feed: NewsFeed
    
    /**
    @show_in_main is a boolean that shows if a feed is visible in the FeedList or not
     */
    @State private var show_in_main: Bool = true
    /**
    @use_filters is a boolean that shows if a feed is using filters or not
     */
    @State private var use_filters: Bool = false
    /**
    @name is a string that holds the input of the user
     */
    @State private var name = ""
    
    /**
     @presentationMode make the View dismiss itself
     */
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            
            HStack {
                Text("Name")
                    .padding(20.0)
                TextField(
                    feed.name,
                    text: $name
                ).textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20.0)
            }
            
            HStack{
                Toggle("Show in Main Feed", isOn: $show_in_main)
                    .onChange(of: show_in_main){value in
                        feed.show_in_main = value
                        print("Called toggle Show in Main Feed = \(feed.show_in_main)")
                    }
                    .padding(.horizontal,20.0)
            }
            
            HStack{
                Toggle("Use Filters",isOn: $use_filters)
                    .onChange(of: use_filters){value in
                        feed.use_filters = value
                        print("Called toggle User Filters = \(feed.use_filters)")
                    }
                    
                    .padding(.horizontal,20.0)
                
            }
            List{
                NavigationLink(destination: DummyDetailView()){
                    Text("Filters Selected")
                }
            }
            Spacer()
            
        }
        .navigationBarTitle(feed.name, displayMode: .inline)
        .navigationBarItems(
            trailing:
                Button(action: {
                    print("save_btn pressed")
                    if name != "" {
                        feed.name = name
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                }
        )
    }
}
