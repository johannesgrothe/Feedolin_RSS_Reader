//
//  ArticleView.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 31.10.20.
//

import SwiftUI
import WebKit
import Combine

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
        .background(Color("BackgroundColor"))
        .edgesIgnoringSafeArea(.bottom)
    }
}

/**
 View that loads the url of the article and shows it
 */
struct ArticleWebView: NSViewRepresentable {
    
    typealias NSViewType = WKWebView
    
    // String that represents the url of the article, that is shown
    let url: String
    
    private let web_view: WKWebView = WKWebView()
    
    /**
     creates the view and returns it
     */
    func makeNSView(context: NSViewRepresentableContext<ArticleWebView>) -> WKWebView {
        web_view.navigationDelegate = context.coordinator
        web_view.uiDelegate = context.coordinator as? WKUIDelegate
        web_view.load(URLRequest(url: URL(string: url)!))
        return web_view
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(URL(string: url)!)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        private var url: URL
        
        init(_ url: URL) {
            self.url = url
        }
        
        public func webView(_: WKWebView, didFail: WKNavigation!, withError: Error) { }
        
        public func webView(_: WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error) { }
        
        public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) { }
        
        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            decisionHandler(.allow)
        }
        
    }
    
    /**
     updates the view, needs to be there
     */
    func updateNSView(_ uiView: WKWebView, context: Context) {
        
    }
    
    
    
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(article: ArticleData(article_id: "001", title: "TestArticle", description: "article for test", link: "https://www.apple.com", pub_date: Date(), thumbnail_url: "Test", parent_feeds: []))
    }
}
