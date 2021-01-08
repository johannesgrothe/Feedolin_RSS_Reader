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
     @showingAlert shows if alert is true*/
    @State private var showing_alert = false
    
    /**
     @presentationMode make the View dismiss itself
     */
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var model: Model = .shared
    
    var body: some View {
        VStack {
            /** TextField where the users gives a new name for the feed*/
            HStack {
                Text("Name")
                    .padding(20.0)
                TextField(
                    feed.name,
                    text: $name
                ).textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20.0)
            }
            /**Toggle Button where user can set if the current feed will be shown on mainview*/
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
                    .padding(.horizontal,20.0)
            }
            /**Toggle Button where user can set if the current feed will be use filters*/

            HStack{
                Toggle("Use Filters",isOn: $use_filters)
                    .onAppear(){
                        show_in_main = feed.show_in_main
                    }
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
            
            Button(action: {
                withAnimation {
                    self.showing_alert = true
                }
            }) {
                /** Alert Button that will call a Alert if users wants to remove the feed*/
                HStack{
                    Image(systemName: "trash").imageScale(.large)
                    Text("Remove Feed").font(.headline)
                }
            }
            .alert(isPresented: $showing_alert) {
                Alert(title: Text("Removing Feed"), message: Text("WARNING: This action will irreversible delete the subscribed Feed and all of his Articles(Bookmarked Articles: \(feed.getAmountOfBookmarkedArticles())). If this is the last Feed, the Feed Provider will be deleted, too."), primaryButton: .default(Text("Okay"), action: {
                        model.removeFeed(feed)
                        self.presentationMode.wrappedValue.dismiss()
                }),secondaryButton: .cancel())
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
