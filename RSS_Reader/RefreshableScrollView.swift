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
        makes the RefreshView
     */
    func makeUIView(context: Context) -> UIScrollView {
        let control = UIScrollView()
        control.refreshControl = UIRefreshControl()
        control.refreshControl?.addTarget(context.coordinator, action:
                                            #selector(Coordinator.handleRefreshControl),
                                          for: .valueChanged)
        let childView = UIHostingController(rootView: ArticleList(model: model))
        childView.view.frame = CGRect(x: -20, y: -40, width: width+40, height: height)
        
        control.addSubview(childView.view)
        return control
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
        }
    }

}

struct RefreshableScrollView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader{
            geometry in
            RefreshableScrollView(width: geometry.size.width, height: geometry.size.height,model: preview_model)
        }
    }
}
