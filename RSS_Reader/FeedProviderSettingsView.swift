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
    @ObservedObject var feed_provider: NewsFeedProvider
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
        VStack(spacing: 30)  {
            // image and change-button
            ZStack{
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
                }, label: {
                    Image(systemName: "pencil.circle")
                        .resizable()
                        .frame(width: 35, height: 35)
                        
                })
                .foregroundColor(Color("ButtonColor"))
                .offset(x: 35, y: 35)
                
            }
            .frame(width: 100, height: 100, alignment: .center)
            .padding(.horizontal)
            
            // row with original url
            HStack{
                Text("URL")
                Spacer()
                Text(feed_provider.url)
                    .font(.subheadline)
            }
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
                            feed_provider.name = self.name
                            self.name = ""
                        }
                    // x-button
                    Button(action: {
                        self.name = ""
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .opacity(self.name == "" ? 0 : 1)
                    })
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
                            feed_provider.token = self.abbreviation
                            self.abbreviation = ""
                        }
                    // x-button
                    Button(action: {
                        self.abbreviation = ""
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .opacity(self.abbreviation == "" ? 0 : 1)
                    })
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
        .padding(.top)
        .defaultScreenLayout()
        .navigationBarTitle(feed_provider.name, displayMode: .inline)
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
        FeedProviderSettingsView(feed_provider: NewsFeedProvider(url: "test.de", name: "TestProvider", token: "TP", icon_url: "blub/x.jpg", feeds: []))
    }
}
