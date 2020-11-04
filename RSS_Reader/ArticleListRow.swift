//
//  ArticleListRow.swift
//  RSS_Reader
//
//  Created by Emircan Duman on 04.11.20.
//

import SwiftUI

struct ArticleListRow: View {
    var article: Article
    
    var body: some View {
        HStack {
            article.image
                .resizable()
                .frame(width: 50, height: 50)
            VStack{
                Text(article.title)
                Text(article.description)
                Spacer()
            }
        }
    }
}

struct ArticleListRow_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ArticleListRow(article: articleData[0])
            ArticleListRow(article: articleData[1])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
