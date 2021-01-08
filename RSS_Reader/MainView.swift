//
//  MainView.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 12/22/20.
//

import SwiftUI

/**
 View that contains the hole
 */
struct MainView: View {
    // boolean if side menu is shown
    @Binding var show_menu : Bool
    
    // Model Singleton
    @ObservedObject var model: Model = .shared
    
    //open the sidemenu with animation
    let menu_open: () -> Void
    
    var body: some View {
        // Drag gesture to open the side menu by swiping
        let drag_right = DragGesture().onEnded {
            if $0.translation.width > -100 {
                menu_open()
            }
        }
        
        GeometryReader{
            geometry in
            NavigationView {
                
                RefreshableScrollView(width: geometry.size.width, height: geometry.size.height)
                    .navigationBarTitle(model.filter_option.description, displayMode: .inline)
                    
                    .navigationBarItems(
                        leading:
                            Button(action: {
                                self.menu_open()
                            }) {
                                Image(systemName: "sidebar.left").imageScale(.large)
                            },
                        trailing:
                            NavigationLink(destination: SettingsView()) {
                                Image(systemName: "gear").imageScale(.large)
                            }
                    )
                    .background(Color(UIColor(named: "BackgroundColor")!))
                    .edgesIgnoringSafeArea(.bottom)
                    .gesture(drag_right)
                
            }
            .accentColor(Color(UIColor(named: "ButtonColor")!))
        }
    }
}