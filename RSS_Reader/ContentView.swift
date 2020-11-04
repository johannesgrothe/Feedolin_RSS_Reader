//
//  ContentView.swift
//  RSS_Reader
//
//  Created by Emircan Duman on 29.10.20.
//

import SwiftUI
import CoreData

/**
 Launchscreen of the app
 */
struct ContentView: View {
    @State var menuOpen: Bool = false
    
    var body: some View {
        
        // Drag gesture to open the side menu by swiping
        let drag = DragGesture().onEnded {
                        if $0.translation.width > -100 {
                            withAnimation {
                                self.menuOpen = true
                            }
                        }
                    }
        
        ZStack {
            NavigationView {
                
                ArticleListView()
                .navigationBarTitle("Feed", displayMode: .inline)
                .navigationBarItems(
                    leading:
                        Button(action: {
                            print("MenuButton pressed")
                            self.menuOpen.toggle()
                        }) {
                            Image(systemName: "calendar.circle").imageScale(.large)
                        },
                    trailing:
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gear").imageScale(.large)
                        }
                        .navigationBarTitle("Feed")
                )
            }.gesture(drag)
            
            SideMenuView(width: 270,
                         isOpen: self.menuOpen,
                         menuClose: self.openMenu)
        }
    }

    func openMenu() {
        self.menuOpen.toggle()
    }
}
