//
//  MainView.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 12/22/20.
//

import SwiftUI

/// View that contains the hole
struct MainView: View {
    /// @show_menu is  boolean if side menu is shown
    @Binding var show_menu : Bool
    /// @model is the shared model singelton
    @ObservedObject var model: Model = .shared
    /// @menu_open is a function to open the sidemenu with animation
    let menu_open: () -> Void
    
    var body: some View {
        // Drag gesture to open the side menu by swiping
        let drag_right = DragGesture().onEnded {
            if $0.translation.width > -100 {
                menu_open()
            }
        }
        NavigationView {
            ArticleList(model: model)
            .defaultScreenLayout()
            .navigationBarTitle(model.filter_option.description, displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        self.menu_open()
                    }, label: {
                        CustomSystemImage(image: .side_menu)
                    }),
                trailing:
                    // container for right navigation items
                    HStack {
                        WaitingButton(action: {
                            model.fetchFeeds()
                        }, publisher: model.$is_fetching)
                        
                        Button(action: {
                            model.hide_read_articles = !model.hide_read_articles
                            model.refreshFilter()
                        }) {
                            if model.hide_read_articles {
                                CustomSystemImage(image: .hide_read)
                            } else {
                                CustomSystemImage(image: .show_read)
                            }
                        }
                        
                        NavigationLink(destination: SettingsView()) {
                            CustomSystemImage(image: .settings)
                        }
                    }
            )
            .gesture(drag_right)
        }
        .autoNavigationViewStyle()
    }
}
