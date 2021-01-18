//
//  FeedProviderSettingsView.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 07.11.20.
//

import SwiftUI

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
        Form {
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
            .padding(.horizontal)

            HStack{
                Text("URL:")
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
                        if self.name != ""{
                            feed_provider.name = self.name
                        }
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
                        if self.abbreviation != ""{
                            feed_provider.token = self.abbreviation
                        }
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
                .foregroundColor(.secondary)
                .cornerRadius(10)
            }
            .padding(.horizontal)
            Spacer()
        }
        .padding(.top)
        .edgesIgnoringSafeArea(.bottom)
    }
}

