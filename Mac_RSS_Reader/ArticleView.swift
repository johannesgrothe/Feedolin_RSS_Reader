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
        ArticleWebView(url: URL(string: article.link)!)
            .frame(minWidth: 750)
    }
}

struct ArticleWebView: NSViewRepresentable {
    
    public typealias NSViewType = WKWebView

    private let web_view: WKWebView = WKWebView()
    
    let url: URL?

    public func load(url: URL) {
        web_view.load(URLRequest(url: url))
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    public func makeNSView(context: NSViewRepresentableContext<ArticleWebView>) -> WKWebView {

        web_view.navigationDelegate = context.coordinator
        web_view.uiDelegate = context.coordinator
        web_view.load(URLRequest(url: url!))
        return web_view
    }

    public func updateNSView(_ nsView: WKWebView, context: NSViewRepresentableContext<ArticleWebView>) {

    }
}

class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {

    var parent: ArticleWebView

    init(parent: ArticleWebView) {
        self.parent = parent
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }

    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}


struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(article: ArticleData(article_id: "001", title: "TestArticle", description: "article for test", link: "https://www.apple.com", pub_date: Date(), thumbnail_url: "Test", parent_feeds: []))
    }
}
