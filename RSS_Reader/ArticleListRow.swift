//
//  ArticleListRow.swift
//  RSS_Reader
//
//  Created by Emircan Duman on 04.11.20.
//

import SwiftUI

/**
 View that represents a article cell
 */

struct ArticleListRow: View {
    
    var article: ArticleData
    var image: Image
    
    var body: some View {
        NavigationLink(destination: ArticleView()){
            HStack {
                
                VStack{
                    Text(article.title)
                        .font(.custom("article_titel", size: 19))
                    HStack{
                        Text("feed_provider_name")
                            .font(.custom("parent_feed_provider_name", size: 10))
                        
                        Text(article.date_to_string())
                            .font(.custom("article_pub_date", size: 10))
                    }
                    Text(article.description)
                        .font(.subheadline)
                }
                
                Spacer()
                
                //Image(article.image)
                image
                    .resizable()
                    .frame(width: 130, height: 115)
            }
            .frame(alignment: .center)
        }
    }
    
    struct ArticleListRow_Previews: PreviewProvider {
        static var previews: some View {
            
            let img0 = Image("824cf0bb-20a4-4655-a50e-0e6ff7520d0f")
            let img1 = Image("c9f82579-efeb-4ed5-bf07-e10edafc3a4d")
            
            Group{
                ArticleListRow(article: model.article_data[0],image: img0)
                ArticleListRow(article: model.article_data[1],image: img1)
            }
        }
    }
}
