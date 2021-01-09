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
    @State private var show_add_feed_view = false
    
    /** The search phrase entered in the search bar */
    @State private var search_phrase = ""
    
    /** The representation of the 'ignore casing while searching'-selectors */
    @State private var search_ignore_casing = true
    
    var body: some View {
        let min_width: CGFloat = 350
        NavigationView{
            List {
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
            .frame(minWidth: min_width)
            .edgesIgnoringSafeArea(.bottom)
            .listStyle(PlainListStyle())
        }
        .toolbar{
            ToolbarItem(placement: ToolbarItemPlacement.navigation){
                // Search bar
                HStack {
                    //search bar magnifying glass image
                    Image(systemName: "magnifyingglass").foregroundColor(.secondary)
                    
                    //search bar text field
                    TextField("search", text: $search_phrase)
                    
                    // x Button
                    Button(action: {
                        search_phrase = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
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
                                .foregroundColor(.secondary)
                        } else {
                            Image(systemName: "textformat")
                                .foregroundColor(.secondary)
                        }
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    
                }
                .frame(idealWidth:min_width)
                .padding(8)
                .cornerRadius(8)
                .listRowBackground(Color.clear)
            }
            ToolbarItem(placement: ToolbarItemPlacement.navigation) {
                Menu {
                    /**
                     displayes all-button
                     */
                    Button(action: {
                        model.setFilterAll()
                        model.refreshFilter()
                    }) {
                        Label("All", systemImage: "infinity.circle.fill")
                            .frame(width: 22   , height: 22, alignment: .leading)
                            .scaledToFit()
                            .font(.headline)
                    }
                    /**
                     displayes booksmark-button
                     */
                    Button(action: {
                        model.setFilterBookmarked()
                        model.refreshFilter()
                    }) {
                        Label("Bookmarked",systemImage:"bookmark.circle.fill")
                            .frame(width: 22, height: 22, alignment: .leading)
                            .scaledToFit()
                            .font(.headline)
                    }
                    
                }
                label: {
                    Label("Filter", systemImage: "line.horizontal.3.decrease.circle").imageScale(.large)
                }
            }
            ToolbarItem(placement: ToolbarItemPlacement.navigation){
                Button(action: {
                    print("Add feed button clicked")
                    self.show_add_feed_view.toggle()
                }) {
                    Label("Add Feed", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: self.$show_add_feed_view) {
            AddFeedView()
        }
    }
}

struct ArticleList_Previews: PreviewProvider {
    static var previews: some View {
        ArticleList(model: preview_model)
    }
}
