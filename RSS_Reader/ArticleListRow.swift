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
        NavigationLink(destination: ArticleView(article: article)){
            // VStack with text to the left and image to the right
            HStack {
                // article.title on top following by HStack and article.description
                VStack(alignment: .leading, spacing: 8.0){
                    
                    Text(article.title)
                        .font(.subheadline)
                        .bold()
                        .lineLimit(4)
                        .layoutPriority(1)
                    // parent_feed indicators to the left than seperator and pubdate to the right
                    HStack {
                        Text("\(article.parent_feeds[0].parent_feed.token) - \(article.parent_feeds[0].name)")
                            .font(.caption2)
                            .lineLimit(1)
                        Text("|").font(.caption2)
                        Text(article.time_ago_date_to_string())
                            .font(.caption2)
                            .italic()
                            .lineLimit(1)
                        
                    }
                    
                    Text(article.description)
                        .font(.caption)
                        .lineLimit(4)
                }
                
                Spacer()
                
                //Image(article.image)
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 110, maxHeight: 180, alignment: .center)
                
            }
        }
        .frame(minHeight: 120, maxHeight: 200)
        .padding(.all, 10.0)
        .background(Color(UIColor(named: "ArticleColor")!))
        .cornerRadius(10)
        
    }
    
    struct ArticleListRow_Previews: PreviewProvider {
        
        @ObservedObject var model: Model = .shared
        
        static var previews: some View {
            
            let img0 = Image("824cf0bb-20a4-4655-a50e-0e6ff7520d0f")
            let img1 = Image("c9f82579-efeb-4ed5-bf07-e10edafc3a4d")
            
            Group{
                ArticleListRow(article: preview_model.stored_article_data[0],image: img0)
                ArticleListRow(article: preview_model.stored_article_data[1],image: img1)
            }
        }
    }
}
