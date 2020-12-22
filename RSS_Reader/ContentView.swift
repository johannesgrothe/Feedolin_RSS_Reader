//
//  ContentView.swift
//  RSS_Reader
//
//  Created by Emircan Duman on 29.10.20.
//

import SwiftUI
import CoreData

/**
 First Screen of the App
 */
struct ContentView: View {
    // boolean if side menu is shown
    @State var show_menu: Bool = false
    
    // Model Singleton
    @ObservedObject var model: Model = .shared
    
    var body: some View {
        // Drag gesture to open the side menu by swiping
        let drag_right = DragGesture().onEnded {
            if $0.translation.width > -100 {
                slideAnimation()
            }
        }
        // Drag gesture to close the side menu by swiping
        let drag_left = DragGesture().onEnded {
            if $0.translation.width < -100 {
                slideAnimation()
            }
        }
        let width_sidemenu: CGFloat = 270
        //
        ZStack {
            SideMenuView(show_menu: self.$show_menu, menu_close: self.slideAnimation)
                .offset(x: self.show_menu ? 0 : -width_sidemenu)
                .opacity(self.show_menu ? 1 : 0.1)
                .disabled(self.show_menu ? false : true)
                .gesture(drag_left)
//                .onTapGesture {
//                    slideAnimation()
//                }
            MainView(show_menu: self.$show_menu)
                .offset(x: self.show_menu ? width_sidemenu : 0)
                .disabled(self.show_menu ? true : false)
                .gesture(drag_right)
            
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    func slideAnimation() {
        return withAnimation(.linear) {
            self.show_menu.toggle()
        }
    }
}

/**
 UINavigationController for the overall UINavigationBarAppearance
 */
extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "TopbarColor")!
        navigationBar.standardAppearance = appearance
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(show_menu: false, model: preview_model)
    }
}
