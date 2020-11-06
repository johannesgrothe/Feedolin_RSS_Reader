//
//  ArticleList.swift
//  RSS_Reader
//
//  Created by Emircan Duman on 04.11.20.
//

import SwiftUI

/**
 View that represents a list of article cells*/

struct ArticleList: View {
    
    var body: some View {
        NavigationView {
            List {
                ForEach(model.article_data){ article in
                    ArticleListRow(article: article, image: Image("824cf0bb-20a4-4655-a50e-0e6ff7520d0f"))
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
