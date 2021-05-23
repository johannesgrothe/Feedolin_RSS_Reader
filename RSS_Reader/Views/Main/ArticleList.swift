//
//  ArticleList.swift
//  RSS_Reader
//
//  Created by Emircan Duman on 04.11.20.
//

import Foundation
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
    @State private var search_phrase: String = ""
    /**
     @search_ignore_casing is the representation of the 'ignore casing while searching'-selectors
     */
    @State private var search_ignore_casing: Bool = true
    
    @State private var scroll_offset: CGFloat = .zero
    
    var textfield_row: some View {
        HStack {
            CustomTextfield(image: .search,
                            placholder: "search_bar_textfield".localized,
                            text: $search_phrase,
                            on_commit: {})
            // Casing selector
            TButton(action: {
                print("Ignore Casing set to \(search_ignore_casing)")
            }, image_one: .insensitive, image_two: .sensitive,
            bool: $search_ignore_casing)
        }
        .padding([.horizontal, .top], 10)
    }
    
    var body: some View {
        ZStack {
            ScrollViewReader { scroll_view in
                ZStack {
                    // Scroll View with content
                    ScrollViewOffset(shows_indicators: false, on_offset_change: {
                        scroll_offset = $0
                    }, content: {
                        LazyVStack(alignment: .center, pinnedViews: [], content: {
                            Section(header: textfield_row) {
                                EmptyView().id(0)
                                /// Create search object
                                let search_phrase_obj = SearchPhrase(pattern: search_phrase,
                                                                 is_regex: false,
                                                                 search_description: true,
                                                                 ignore_casing: search_ignore_casing)
                                /// filter list with search phrase
                                let filtered_list = model.filtered_article_data.filter { (article) -> Bool in
                                    if !self.search_phrase.isEmpty {
                                        return search_phrase_obj.matchesArticle(article)
                                    }
                                    return true
                                }
                                
                                ForEach(filtered_list){ article in
                                    ArticleCellView(article: article)
                                        .padding(.top, 5)
                                        .padding(.horizontal, 10)
                                }
                            }
                        })
                        
                    })
                    
                    // jump to top button
                    VStack(alignment: .trailing) {
                        Spacer()
                        HStack(alignment: .bottom) {
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    scroll_view.scrollTo(0, anchor: .center)
                                }
                            }, label: {
                                CustomSystemImage(image: .spring_to_top, style: .circle, size: .xxlarge, color: .button)
                                    .background(Color.topbar)
                                    .cornerRadius(100)
                                    .padding()
                                    .shadow(color: .button, radius: 7)
                            })
                        }
                        .padding(.bottom, 40)
                        .padding(.trailing, 10)
                        .opacity(scroll_offset < -400 ? 1 : 0)
                        .animation(.easeInOut)
                    }
                }
            }
        }
    }
}

struct ArticleList_Previews: PreviewProvider {
    static var previews: some View {
        ArticleList(model: fake_data_preview)
        
    }
}
