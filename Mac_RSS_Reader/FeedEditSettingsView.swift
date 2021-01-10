//
//  FeedEditSettingsView.swift
//  RSS_Reader
//
//  Created by Emircan Duman on 10.11.20.
//

import SwiftUI

struct FeedEditSettingsView: View {
    
    /**
     @feed is the NewsFeed to be editing
     */
    @ObservedObject var feed: NewsFeed
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
     @isEditing is the indicator if the user is editing the textfield
     */
    @State private var isEditing: Bool = false
    
    /**
     @showingAlert shows if alert is true*/
    @State private var showing_alert = false
    
    /**
     @presentationMode make the View dismiss itself
     */
    @Environment(\.presentationMode) var presentationMode
    /**
     @model is the shared model singelton
     */
    @ObservedObject var model: Model = .shared
    
    var body: some View {
        // hole content
        VStack(spacing: 30) {
            // row with original url
            HStack{
                Text("URL")
                Text(feed.url)
                    .font(.subheadline)
                Spacer()
            }
            .padding(.horizontal)
            
            // row with name and textfield
            HStack {
                Text("Name")
                    .padding(.trailing)
                // input textfield
                HStack {
                    TextField(feed.name, text: $name) { isEditing in
                        self.isEditing = isEditing
                        } onCommit: {
                            feed.name = self.name
                            self.name = ""
                        }
                    .frame(width:200)
                    // x-button
                    Button(action: {
                        self.name = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .opacity(self.name == "" ? 0 : 1)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                .padding(10)
                .cornerRadius(10)
                Spacer()
            }
            .padding(.horizontal)
            
            // show in main feed toggle
            HStack{
                Toggle("Show in Main Feed", isOn: $show_in_main)
                    .onAppear(){
                        show_in_main = feed.show_in_main
                    }
                    .onChange(of: show_in_main){value in
                        feed.show_in_main = value
                        print("Called toggle Show in Main Feed = \(feed.show_in_main)")
                    }
                    .onDisappear(){
                        model.refreshFilter()
                    }
                Spacer()
            }
            .padding(.horizontal)
            
            // use filters toggle
            HStack{
                Toggle("Use Filters",isOn: $use_filters)
                    .onAppear(){
                        use_filters = feed.use_filters
                    }
                    .onChange(of: use_filters){value in
                        feed.use_filters = value
                        print("Called toggle User Filters = \(feed.use_filters)")
                    }
                Spacer()
            }
            .padding(.horizontal)

            HStack{
                Button(action: {
                    withAnimation {
                        self.showing_alert = true
                    }
                }) {
                    /** Alert Button that will call a Alert if users wants to remove the feed*/
                    HStack{
                        Image(systemName: "trash").imageScale(.large)
                            .foregroundColor(Color.red)
                        Text("Remove Feed").font(.headline)
                            .foregroundColor(Color.red)
                    }
                }
                .padding(.horizontal)
                .alert(isPresented: $showing_alert) {
                    Alert(title: Text("Removing Feed"), message: Text("WARNING: This action will irreversible delete the subscribed Feed and all of his Articles(Bookmarked Articles: \(feed.getAmountOfBookmarkedArticles())). If this is the last Feed, the Feed Provider will be deleted, too."), primaryButton: .default(Text("Okay"), action: {
                        model.removeFeed(feed)
                    }),secondaryButton: .cancel())
                }
                Spacer()
            }
            Spacer()
        }
        .navigationTitle(feed.name)
        .padding(.top)
        .edgesIgnoringSafeArea(.bottom)
        .onDisappear(perform: {
            if name != "" {
                feed.name = name
            }
        })
    }
}
