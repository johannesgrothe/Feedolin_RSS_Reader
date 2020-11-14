//
//  ArticleView.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 31.10.20.
//

import SwiftUI

/**
 View that contains the whole article. Used to read the article.
 */
struct ArticleView: View {
    var body: some View {
        VStack{
            Spacer()
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Spacer()
        }
        .background(Color(UIColor(named: "BackgroundColor")!))
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView()
    }
}
