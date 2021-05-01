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
    
    // thw width of the side menu
    let width_sidemenu: CGFloat = 270
    
    var body: some View {
        // underlaying MainView and on top the SideMenuView
        ZStack {
            MainView(show_menu: self.$show_menu, menu_open: self.slideAnimation)
                .offset(x: self.show_menu ? width_sidemenu : 0)
                .disabled(self.show_menu ? true : false)
            // Rectangle on bottom and only show when Sidemenu open
            ZStack(alignment: .leading) {
                Rectangle()
                    .edgesIgnoringSafeArea(.all)
                    .foregroundColor(.black)
                    .disabled(self.show_menu ? false : true)
                    .opacity(self.show_menu ? 0.3 : 0)
                    .onTapGesture {
                        self.slideAnimation()
                    }
                
                SideMenuView(width: self.width_sidemenu, show_menu: self.$show_menu, menu_close: self.slideAnimation)
                    .offset(x: self.show_menu ? 0 : -width_sidemenu)
                    .disabled(self.show_menu ? false : true)
            }
        }
        .onAppear(perform: {
            UITableView.appearance().backgroundColor = .clear
            UITableViewCell.appearance().backgroundColor = .clear
            UITableView.appearance().showsVerticalScrollIndicator = false
        })
    }
    
    func slideAnimation() {
        return withAnimation(.linear) {
            self.show_menu.toggle()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(show_menu: false, model: fake_data_preview)
    }
}
