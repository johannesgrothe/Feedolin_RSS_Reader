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
    
    let url: String
    
    var body: some View {
        VStack{
            ArticleWebView(url: url)
        }
        .background(Color(UIColor(named: "BackgroundColor")!))
        .edgesIgnoringSafeArea(.bottom)
    }
}

/**
 View that loads the url of the article and shows it
 */
struct ArticleWebView: UIViewRepresentable {
    
    let url: String
    
    /**
     creates the view and returns it
     */
    func makeUIView(context: Context) -> WKWebView {
        //test url from url-String
        guard let url = URL(string: self.url) else {
            return WKWebView()
        }
        // creates request and load url
        let request = URLRequest(url: url)
        let wkView = WKWebView()
        wkView.load(request)
        
        return wkView
    }
    
    /**
     updates the view, needs to be there
     */
    func updateUIView(_ uiView: WKWebView, context: Context) {

    }
    
    
    
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(url: "https://www.apple.com")
    }
}
