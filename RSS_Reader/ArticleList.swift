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
    
    var body: some View {
        List {
            // for preview  model.stored_article_data and not model.filtered_article_data
            ForEach(model.filtered_article_data){ article in
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
