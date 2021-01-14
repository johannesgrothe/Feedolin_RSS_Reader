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
    
    /**
     @model is the shared model singelton
     */
    @ObservedObject var model: Model = .shared
    /**
     @search_phrase is the search phrase entered in the search bar
     */
    @State private var search_phrase = ""
    /**
     @search_ignore_casing is the representation of the 'ignore casing while searching'-selectors
     */
    @State private var search_ignore_casing = true
    
    var body: some View {
        List {
            
            // Search bar
            HStack {
                //search bar magnifying glass image
                Image(systemName: "magnifyingglass")
                            
                //search bar text field
                TextField("search_bar_textfield".localized, text: $search_phrase)
                   
                // x Button
                Button(action: {
                    search_phrase = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .opacity(search_phrase == "" ? 0 : 1)
                }
                .buttonStyle(BorderlessButtonStyle())
                
                // Casing selector
                Button(action: {
                    search_ignore_casing = !search_ignore_casing
                    print("Ignore Casing set to \(search_ignore_casing)")
                }) {
                    if search_ignore_casing {
                        Image(systemName: "textformat.size.larger")
                    } else {
                        Image(systemName: "textformat")
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                
            }
            .listRowBackground(Color.clear)
            .padding(10)
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            
            
            /** Create search object */
            let search_obj = SearchPhrase(pattern: search_phrase,
                                          is_regex: false,
                                          search_description: true,
                                          ignore_casing: search_ignore_casing)
            
            /** filter article list */
            let display_list = model.filtered_article_data.filter { (article) -> Bool in
                if !self.search_phrase.isEmpty {
                    return search_obj.matchesArticle(article)
                }
                return true
            }
            
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
