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
    /**
     @show_menu is  boolean if side menu is shown
     */
    @Binding var show_menu : Bool
    /**
     @model is the shared model singelton
     */
    @ObservedObject var model: Model = .shared

    /**
     * Indicates which color scheme is selected by the user
     */
    @AppStorage("dark_mode_enabled") var dark_mode_enabled: Int = 0

    /**
     @menu_open is a function to open the sidemenu with animation
     */
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
                            
                            // container for right navigation items
                            HStack {
                                Button(action: {
                                    model.hide_read_articles = !model.hide_read_articles
                                    model.refreshFilter()
                                }) {
                                    if model.hide_read_articles {
                                        Image(systemName: "eye.slash").imageScale(.large)
                                    } else {
                                        Image(systemName: "eye").imageScale(.large)
                                    }
                                    
                                }
                                
                                NavigationLink(destination: SettingsView()) {
                                    Image(systemName: "gear").imageScale(.large)
                                }
                            }
                        
                        
                    )
                    .background(Color(UIColor(named: "BackgroundColor")!))
                    .edgesIgnoringSafeArea(.bottom)
                    .gesture(drag_right)
                
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .accentColor(Color(UIColor(named: "ButtonColor")!))
//            .onAppear(perform: settings_view.overrideColorScheme)
            .onAppear(perform: { overrideColorScheme(theme_index: dark_mode_enabled) } )
        }
    }
}
