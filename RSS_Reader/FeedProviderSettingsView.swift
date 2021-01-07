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
    
    /**
     @feed_provider is the NewsFeedProvider to be editing
     */
    let feed_provider: NewsFeedProvider
    /**
     @name is a string that holds the input of the user
     */
    @State private var name = ""
    /**
     @abbreviation also token or short_name is a string that holds the input of the user
     */
    @State private var abbreviation = ""
    /**
     @isEditing is the indicator if the user is editing the textfield
     */
    @State private var isEditing: Bool = false
    /**
     @presentationMode make the View dismiss itself
     */
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        // hole content
        VStack(spacing: 20)  {
            // image and change-button
            ZStack{
                // image of provider
                feed_provider.icon.img
                    .resizable()
                    .frame(width: 140, height: 140)
                    .cornerRadius(100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(Color("ButtonColor"), lineWidth: 4)
                            .foregroundColor(.clear)
                    )
                // background of change image button
                Circle()
                    .frame(width: 39, height: 39)
                    .foregroundColor(Color("BackgroundColor"))
                    .offset(x: 50, y: 50)
                
                // change image button
                Button(action: {
                    print("change image pressed")
                }) {
                    Image(systemName: "pencil.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                        
                }
                .foregroundColor(Color("ButtonColor"))
                .offset(x: 50, y: 50)
                
            }
            .frame(width: 140, height: 140, alignment: .leading)
            .padding(.horizontal)
            
            // row with name and textfield
            HStack {
                Text("Name")
                    .padding(.trailing)
                // input textfield
                HStack{
                    TextField(feed_provider.name, text: $name) { isEditing in
                        self.isEditing = isEditing
                        } onCommit: {
                            feed_provider.name = name
                        }
                    // x-button
                    Button(action: {
                        name = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .opacity(name == "" ? 0 : 1)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                .padding(10)
                .background(Color(.secondarySystemBackground))
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
                            feed_provider.token = abbreviation
                        }
                    // x-button
                    Button(action: {
                        abbreviation = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .opacity(abbreviation == "" ? 0 : 1)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .foregroundColor(.secondary)
                .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(10)
        .background(Color("BackgroundColor"))
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitle(feed_provider.url, displayMode: .inline)
        .onDisappear(perform: {
            if name != "" {
                feed_provider.name = name
            }
            if abbreviation != "" {
                feed_provider.token = abbreviation
            }
        })
    }
}

struct FeedProviderSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        FeedProviderSettingsView(feed_provider: NewsFeedProvider(url: "test.de", name: "TestProvider", token: "TP", icon_url: "blub/x.jpg", feeds: []))
    }
}
