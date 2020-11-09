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
                
                VStack(alignment: .leading){
                    
                    Text(article.title)
                        .font(.title2)
                        .lineLimit(1)
                    HStack{
                        Text("provider_name")
                            .font(.caption2)
                        
                        Text(article.date_to_string())
                            .font(.caption2)
                    }
                    Text(article.description)
                        .font(.subheadline)
                }
                .frame(minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: 115, maxHeight: 115)
                Spacer()
                //Image(article.image)
                image
                    .resizable()
                    .frame(width: 130, height: 115)
            }
        }
    }
    
    struct ArticleListRow_Previews: PreviewProvider {
        
        @ObservedObject var model: Model = .shared
        
        static var previews: some View {
            
            let img0 = Image("824cf0bb-20a4-4655-a50e-0e6ff7520d0f")
            let img1 = Image("c9f82579-efeb-4ed5-bf07-e10edafc3a4d")
            
            Group{
                ArticleListRow(article: preview_model.article_data[0],image: img0)
                ArticleListRow(article: preview_model.article_data[1],image: img1)
            }
        }
    }
}
