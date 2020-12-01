//
//  ArticleView.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 31.10.20.
//

import SwiftUI
import WebKit

/**
 View that contains the whole article. Used to read the article.
 */
struct ArticleView: View {
    
    // the complete article in the view
    let article: ArticleData
    
    var body: some View {
        VStack{
            ArticleWebView(url: article.link)
        }
        .navigationBarTitle(article.title, displayMode: .inline)
        .background(Color(UIColor(named: "BackgroundColor")!))
        .edgesIgnoringSafeArea(.bottom)
    }
}

/**
 View that loads the url of the article and shows it
 */
struct ArticleWebView: UIViewRepresentable {
    
    // String that represents the url of the article, that is shown
    let url: String
    
    /**
     creates the view and returns it
     */
    func makeUIView(context: Context) -> WKWebView {
        //test url from url-String
        guard let url = URL(string: self.url) else {
            return WKWebView()
        }
        // the url-request from url
        let request = URLRequest(url: url)
        // the WebkitView that loads the website
        let wk_view = WKWebView()
        wk_view.load(request)
        
        return wk_view
    }
    
    /**
     updates the view, needs to be there
     */
    func updateUIView(_ uiView: WKWebView, context: Context) {

    }
    
    
    
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(article: ArticleData(article_id: "001", title: "TestArticle", description: "article for test", link: "https://www.apple.com", pub_date: Date(), author: "Test", parent_feeds: []))
    }
}
