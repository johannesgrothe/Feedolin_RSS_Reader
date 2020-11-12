//
//  AddEditFeedView.swift
//  RSS_Reader
//
//  Created by Emircan Duman on 10.11.20.
//

import SwiftUI

/**
 A view to let the user edit feed articles settings
 */

struct AddEditFeedView: View {
    
    let feed_article: NewsFeed
    
    @State private var show_in_main: Bool = true
    @State private var use_filters: Bool = false
    @State private var name = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            
            HStack {
                Text("Name")
                    .padding(20.0)
                TextField(
                    feed_article.name,
                    text: $name
                ).textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20.0)
            }
            
            HStack{
                Toggle("Show in Main Feed", isOn: $show_in_main)
                    .onChange(of: show_in_main){value in
                        feed_article.show_in_main = value
                        print("Called toggle Show in Main Feed = \(feed_article.show_in_main)")
                    }
                    .padding(.horizontal,20.0)
            }
            
            HStack{
                Toggle("Use Filters",isOn: $use_filters)
                    .onChange(of: use_filters){value in
                        feed_article.use_filters = value
                        print("Called toggle User Filters = \(feed_article.use_filters)")
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
        .navigationBarTitle(feed_article.name, displayMode: .inline)
        .navigationBarItems(
            trailing:
                Button(action: {
                    print("save_btn pressed")
                    if name != "" {
                        feed_article.name = name
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                }
        )
    }
}

