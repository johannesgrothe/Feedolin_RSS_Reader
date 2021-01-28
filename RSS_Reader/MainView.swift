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
    /// IconStyle that indicates the style of every icon
    @AppStorage("image_style_int") var image_style_int: Int = ImageStyle.square_rounded.rawValue
    /// IconSize that indicates the size of every icon
    @AppStorage("image_size_int") var image_size_int: Int = IconSize.medium.rawValue
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
                    .defaultScreenLayout()
                    .navigationBarTitle(model.filter_option.description, displayMode: .inline)
                    .navigationBarItems(
                        leading:
                            Button(action: {
                                self.menu_open()
                            }, label: {
                                CustomIcon(icon: .side_menu, style: ImageStyle.init(rawValue: image_style_int)!, size: IconSize.init(rawValue: image_size_int)!)
                            }),
                        trailing:
                            // container for right navigation items
                            HStack {
                                Button(action: {
                                    model.hide_read_articles = !model.hide_read_articles
                                    model.refreshFilter()
                                }) {
                                    if model.hide_read_articles {
                                        CustomIcon(icon: .hide_read, style: ImageStyle.init(rawValue: image_style_int)!, size: IconSize.init(rawValue: image_size_int)!)
                                    } else {
                                        CustomIcon(icon: .show_read, style: ImageStyle.init(rawValue: image_style_int)!, size: IconSize.init(rawValue: image_size_int)!)
                                    }
                                }
                                
                                NavigationLink(destination: SettingsView()) {
                                    CustomIcon(icon: .settings, style: ImageStyle.init(rawValue: image_style_int)!, size: IconSize.init(rawValue: image_size_int)!)
                                }
                            }
                    )
                    .gesture(drag_right)
                
            }
            .autoNavigationViewStyle()
        }
    }
}
