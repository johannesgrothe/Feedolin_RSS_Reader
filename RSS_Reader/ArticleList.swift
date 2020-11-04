//
//  ArticleList.swift
//  RSS_Reader
//
//  Created by Emircan Duman on 04.11.20.
//

import SwiftUI

struct ArticleList: View {
    @EnvironmentObject private var store_data: StoreData
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store_data.articles){ article in
                    ArticleListRow(article: article)
                }
            }
            .navigationBarTitle(Text("Articles"))
        }
    }
}

struct ArticleList_Previews: PreviewProvider {
    static var previews: some View {
        ArticleList()
    }
}
