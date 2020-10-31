//
//  ContentView.swift
//  RSS_Reader
//
//  Created by Emircan Duman on 29.10.20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var menuOpen: Bool = false

    var body: some View {
        
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
                
                .navigationBarTitle("Master view", displayMode: .inline)
                .navigationBarItems(
                    leading:
                        Button(action: {
                            print("SF Symbol button pressed...")
                            self.menuOpen.toggle()
                        }) {
                            Image(systemName: "calendar.circle").imageScale(.large)
                        },
                    trailing:
                        NavigationLink(destination: DummyDetailView()) {
                            Image(systemName: "gear").imageScale(.large)
                        }
                        .navigationBarTitle("Master view")
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
