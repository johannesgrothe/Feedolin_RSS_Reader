//
//  ArticleList.swift
//  RSS_Reader
//
//  Created by Emircan Duman on 04.11.20.
//

import SwiftUI

/**
 View that represents a list of article cells
 */
struct ArticleList: View {
    
    @ObservedObject var model: Model = .shared
    
    @State private var search_phrase = ""
    @State private var show_cancel_button = false
    
    var body: some View {
        List {
            
            // Search view
                    HStack {
                       //search bar magnifying glass image
                       Image(systemName: "magnifyingglass").foregroundColor(.secondary)
                                
                       //search bar text field
                       TextField("search", text: self.$search_phrase, onEditingChanged: { isEditing in
                       self.show_cancel_button = true
                       })
                       
                       // x Button
                       Button(action: {
                           self.search_phrase = ""
                       }) {
                           Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                                  .opacity(self.search_phrase == "" ? 0 : 1)
                          }
                }
                 .padding(8)
                 .background(Color(.secondarySystemBackground))
                 .cornerRadius(8)
            
            
            let search_obj = SearchPhrase(pattern: search_phrase, is_regex: false, search_description: true, ignore_casing: true)
            let display_list = model.filtered_article_data.filter { (article) -> Bool in
                if !self.search_phrase.isEmpty {
                    return search_obj.matchesArticle(article)
                }
                return true
            }
            
            // for preview  model.stored_article_data and not model.filtered_article_data
            ForEach(display_list){ article in
                ArticleListRow(article: article)
            }
            .listRowBackground(Color.clear)
        }
        .edgesIgnoringSafeArea(.bottom)
        .listStyle(PlainListStyle())
        .onAppear(perform: {
            UITableView.appearance().backgroundColor = .clear
            UITableViewCell.appearance().backgroundColor = .clear
        })
    }
}

struct ArticleList_Previews: PreviewProvider {
    static var previews: some View {
        ArticleList(model: preview_model)
    }
}
