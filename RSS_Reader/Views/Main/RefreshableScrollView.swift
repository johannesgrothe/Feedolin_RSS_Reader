//
//  RefreshableScrollView.swift
//  RSS_Reader
//
//  Created by Emircan Duman on 08.11.20.
//

import SwiftUI

/**
 View that wraps the ArticleList() in a pull down to refresh view.
 */
struct RefreshableScrollView: UIViewRepresentable {
    // width and height from the parent view
    var width : CGFloat
    var height : CGFloat
    
    @ObservedObject var model: Model = .shared
    
    /**
        creates Coordinator
     */
    func makeCoordinator() -> Coordinator {
        Coordinator(self, model: model)
    }
    
    /**
        Function that makes the wrapped View to a child_view and put it into the refreshableView
     */
    func makeUIView(context: Context) -> UIScrollView {
        // the UIScrollView who has everything else in its view
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        // added the refresh control
        view.refreshControl = UIRefreshControl()
        view.refreshControl?.addTarget(context.coordinator, action:
                                            #selector(Coordinator.handleRefreshControl),
                                          for: .valueChanged)
        
        // created childview with the ArticleList()
        // for preview add ArticleList(model: preview_model)
        let child_view = UIHostingController(rootView: ArticleList())
        child_view.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        child_view.view.backgroundColor = .clear
        // add child to Scrollview
        view.addSubview(child_view.view)
        return view
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {}
    
    /**
     Class that represents a Coordinator
     */
    class Coordinator: NSObject {
        var control: RefreshableScrollView
        var model : Model
        
        init(_ control: RefreshableScrollView, model: Model) {
            self.control = control
            self.model = model
        }
        
        @objc func handleRefreshControl(sender: UIRefreshControl) {
            sender.endRefreshing()
            model.fetchFeeds()
        }
    }

}

struct RefreshableScrollView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader{
            geometry in
            RefreshableScrollView(width: geometry.size.width, height: geometry.size.height, model: fake_data_preview)
        }
    }
}
