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
struct FeedProviderListView: View {
    
    @ObservedObject var model: Model = .shared
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HStack{
            NavigationView {
                List{
                    ForEach(model.feed_data){feed_provider in
                        let feed_provider_view = FeedProviderSettingsView(feed_provider: feed_provider)
                        NavigationLink(destination: feed_provider_view){
                            HStack{
                                feed_provider.icon.img
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.red)
                                
                                Text(feed_provider.name)
                                
                                Spacer()
                            }
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .listRowBackground(Color.clear)
                        
                        ForEach(feed_provider.feeds){ feed in
                            let feed_edit_view = FeedEditSettingsView(feed: feed)
                            NavigationLink(destination:feed_edit_view){
                                Text(feed.name)
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading)
                            }
                        }
                    }
                }
                .listStyle(SidebarListStyle())
            }
        }
    }
    
    struct FeedProviderSettingsView: View {
        @ObservedObject var feed_provider: NewsFeedProvider
        
        @State private var name = ""
        /**
         @abbreviation also token or short_name is a string that holds the input of the user
         */
        @State private var abbreviation = ""
        /**
         @isEditing is the indicator if the user is editing the textfield
         */
        @State private var isEditing: Bool = false
        
        @Environment(\.presentationMode) var presentationMode
        
        var body: some View{
            // hole content
            VStack(spacing: 30)  {
                ZStack{
                    // image and change-button
                    // image of provider
                    feed_provider.icon.img
                        .resizable()
                        .frame(width: 100, height: 100)
                        .cornerRadius(100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 100)
                                .stroke(Color("ButtonColor"), lineWidth: 3.5)
                                .foregroundColor(.clear)
                        )
                    // background of change image button
                    Circle()
                        .frame(width: 34, height: 34)
                        .foregroundColor(Color("BackgroundColor"))
                        .offset(x: 35, y: 35)
                    
                    // change image button
                    Button(action: {
                        print("change image pressed")
                    }) {
                        Image(systemName: "pencil.circle")
                            .resizable()
                            .frame(width: 35, height: 35)
                        
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .foregroundColor(Color("ButtonColor"))
                    .offset(x: 35, y: 35)
                }
                .frame(width: 100, height: 100, alignment: .center)
                .padding(.horizontal)
                // row with original url
                HStack{
                    Text("URL:")
                    Text(feed_provider.url)
                        .font(.subheadline)
                }
                
                // row with name and textfield
                HStack {
                    Text("Name")
                        .padding(.trailing)
                    // input textfield
                    HStack{
                        TextField(feed_provider.name, text: $name) { isEditing in
                            self.isEditing = isEditing
                        } onCommit: {
                            feed_provider.name = self.name
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
                        Spacer()
                    }
                    .padding(10)
                    .foregroundColor(.secondary)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                // row with abbreviation and textfield
                HStack {
                    Text("Abbreviation")
                        .padding(.trailing)
                    // input textfield
                    HStack{
                        TextField(feed_provider.token, text: $abbreviation) { isEditing in
                            self.isEditing = isEditing
                        } onCommit: {
                            feed_provider.token = self.abbreviation
                            self.abbreviation = ""
                        }
                        .frame(width:200)
                        // x-button
                        Button(action: {
                            self.abbreviation = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .opacity(self.abbreviation == "" ? 0 : 1)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Spacer()
                    }
                    .padding(10)
                    .foregroundColor(.secondary)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding(.top)
            .edgesIgnoringSafeArea(.bottom)
            .navigationTitle(feed_provider.name)
            .onDisappear(perform: {
                if self.name != "" {
                    feed_provider.name = self.name
                }
                if self.abbreviation != "" {
                    feed_provider.token = self.abbreviation
                }
            })
        }
    }
    
    struct FeedProviderSettingsView_Previews: PreviewProvider {
        static var previews: some View {
            FeedProviderListView()
        }
    }
}
