//
//  FeedSettingsView.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 04.11.20.
//

import SwiftUI

/**
 The view that lets you type in an url and add it to the feeds
 */
struct AddFeedView: View {
    @State private var text = ""
    @State private var loading = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var model: Model = .shared
    
    var body: some View {
        ZStack {
            VStack {
                Text("Add Feed").padding(.top, 10)
                TextField(
                    "Enter URL",
                    text: $text
                ).textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 25.0)
                HStack{
                Button("Add Feed") {
                    loading = true
                    let _ = model.addFeed(url: text)
                    loading = false
                    self.presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .cornerRadius(8)
                .accentColor(Color("ButtonColor"))
                
                Button("Cancel"){
                    self.presentationMode.wrappedValue.dismiss()
                }
                .padding(3)
                .cornerRadius(8)
                .accentColor(Color("ButtonColor"))
            }
                Spacer()
            }.disabled(self.loading)
            .blur(radius: self.loading ? 3 : 0)
            //.background(Color("BackgroundColor"))
            .edgesIgnoringSafeArea(.bottom)
            VStack {
                Text("Loading...")
                ProgressView()
            }.disabled(self.loading)
            .opacity(self.loading ? 1 : 0)
        }
        .frame(minWidth: 250)
    }
}
