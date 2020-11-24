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
            //for preview the not filtered article_data ; model.filtered_article_data
            ForEach(model.article_data){ article in
                ArticleListRow(article: article, image: Image("824cf0bb-20a4-4655-a50e-0e6ff7520d0f"))
                    
            }
            .listRowBackground(Color.clear)
        }
        .edgesIgnoringSafeArea(.bottom)
        .listStyle(DefaultListStyle())
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
