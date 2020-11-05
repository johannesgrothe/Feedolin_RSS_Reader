//
//  ArticleListRow.swift
//  RSS_Reader
//
//  Created by Emircan Duman on 04.11.20.
//

import SwiftUI

struct ArticleListRow: View {

    var article: ArticleData
    var image: Image

    var body: some View {
        
        HStack {
            VStack{
                Text(article.title)
                    .font(.custom("article_titel", size: 19))

                Text(date_to_string(date: article.pub_date))
                    .font(.custom("article_pub_date", size: 12))

                Text(article.description)
                    .font(.subheadline)
            }
            Spacer()
            //article.image
            image
                .resizable()
                .frame(width: 130, height: 115)
        }

        .frame(width: 370, height: 120, alignment: .center)
    }
}

func date_to_string(date: Date) -> String{
    
    let date_formatter = DateFormatter()
        date_formatter.timeStyle = .medium
    
    return date_formatter.string(from: date)
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
