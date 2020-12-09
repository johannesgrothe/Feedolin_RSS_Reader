//
//  ArticleView.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 31.10.20.
//

import SwiftUI
import WebKit
import SafariServices

/**
 View that contains the whole article. Used to read the article.
 */
struct ArticleView: View {
    
    // the complete article in the view
    let article: ArticleData
    
    var body: some View {
        VStack{
            SafariView(url: article.link)
                .onDisappear {
                    article.read = true
                }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea([.bottom, .top])
    }
}

/**
 UPDATE: not used right now, maybe later
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

/**
 View that loads the url of the article and shows it in the safari view
 */
struct SafariView: UIViewControllerRepresentable {
    // String that represents the url of the article, that is shown
    let url: String
    // A binding to the current presentation mode of the view associated with this environment, is need to delegate back
    @Environment(\.presentationMode) var presentation_mode
    
    /**
     a coordinator that implements the delegate protocol
     */
    func makeCoordinator() -> SafariView.Coordinator {
        return Coordinator(self)
    }
    
    /**
     creates the view and returns it
     */
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        // controller configuration
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        config.barCollapsingEnabled = true
        // customize the controller
        let safari_view_controller = SFSafariViewController(url: URL(string: self.url)!, configuration: config)
        safari_view_controller.dismissButtonStyle = .close
        safari_view_controller.preferredBarTintColor = UIColor(named: "TopbarColor")!
        safari_view_controller.preferredControlTintColor = UIColor(named: "ButtonColor")!
        safari_view_controller.delegate = context.coordinator
        return safari_view_controller
    }
    
    /**
     updates the view, needs to be there
     */
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        
    }
}

/**
 This extension implements the coordinator class to handle custom delegates from the safari view controller
 */
extension SafariView {
    class Coordinator: NSObject, SFSafariViewControllerDelegate {
        // parent view
        var parent: SafariView
        // A binding to the current presentation mode of the view associated with this environment, is need to delegate back
        @Environment(\.presentationMode) var presentation_mode
        
        /**
         initialize the parent
         */
        init(_ parent: SafariView){
            self.parent = parent
        }
        
        /**
         function that  is called when the dismiss button is tapped
         delegates to back to the main view
         */
        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            //            print(#function)
            parent.presentation_mode.wrappedValue.dismiss()
        }
        
        /**
         function tells the delegate that the user tapped an Action button
         Not used right now
         for custom activities maybe share-options
         */
        func safariViewController(_ controller: SFSafariViewController, activityItemsFor URL: URL, title: String?) -> [UIActivity] {
            //            print(#function)
            return [UIActivity()]
        }
        
        /**
         function that is called when the website is load sucessfully
         Not used right now
         later maybe for set read property or end progressview
         */
        func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
            //            print(#function)
        }
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(article: ArticleData(article_id: "001", title: "TestArticle", description: "article for test", link: "https://www.apple.com", pub_date: Date(), thumbnail_url: nil, parent_feeds: []))
    }
}
