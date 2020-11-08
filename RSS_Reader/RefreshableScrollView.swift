//
//  RefreshableScrollView.swift
//  RSS_Reader
//
//  Created by Emircan Duman on 08.11.20.
//

import SwiftUI

struct RefreshableScrollView: UIViewRepresentable {
    var width : CGFloat
    var height : CGFloat
    
    @ObservedObject var model: Model = .shared
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, model: model)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let control = UIScrollView()
        control.refreshControl = UIRefreshControl()
        control.refreshControl?.addTarget(context.coordinator, action:
                                            #selector(Coordinator.handleRefreshControl),
                                          for: .valueChanged)
        let childView = UIHostingController(rootView: ArticleList(model: model))
        childView.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        control.addSubview(childView.view)
        return control
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {}
    
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
            NavigationView{
                RefreshableScrollView(width: geometry.size.width, height: geometry.size.height,model: preview_model)
            }
        }
    }
}
