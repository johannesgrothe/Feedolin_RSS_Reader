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
            HStack{
                CustomTextfield(image: .search,
                                placholder: "Search",
                                text: $search_phrase,
                                on_commit: {})
                // Casing selector
                TButton(action: {
                    print("Ignore Casing set to \(search_ignore_casing)")
                }, image_one: .casing_insensitive, image_two: .casing_sensitive,
                bool: $search_ignore_casing)
                
            }
            .listRowBackground(Color.clear)
            
            
            
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
            Spacer()
                .listRowBackground(Color.clear)
        }
        .listStyle(PlainListStyle())
    }
}

struct ArticleList_Previews: PreviewProvider {
    static var previews: some View {
        ArticleList(model: preview_model)
    }
}
