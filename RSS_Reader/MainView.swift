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
    
    var body: some View {
        GeometryReader{
            geometry in
            NavigationView {
                
                RefreshableScrollView(width: geometry.size.width, height: geometry.size.height)
                    .navigationBarTitle(model.filter_option.description, displayMode: .inline)
                    
                    .navigationBarItems(
                        leading:
                            Button(action: {
                                print("MenuButton pressed")
                                self.show_menu.toggle()
                            }) {
                                Image(systemName: "calendar.circle").imageScale(.large)
                            },
                        trailing:
                            NavigationLink(destination: SettingsView()) {
                                Image(systemName: "gear").imageScale(.large)
                            }
                    )
                    .background(Color(UIColor(named: "BackgroundColor")!))
                    .edgesIgnoringSafeArea(.bottom)
                
                
            }
            .accentColor(Color(UIColor(named: "ButtonColor")!))
        }
    }
}
