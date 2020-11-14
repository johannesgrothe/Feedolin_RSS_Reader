//
//  SideMenuView.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 31.10.20.
//

import SwiftUI

/**
 Content of the side Menu
 */
struct MenuContent: View {
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        List {
            HStack {
                Image(systemName: "person").imageScale(.large)
                Text("Profile").font(.headline)
                Spacer()
            }.onTapGesture {
                print("My Profile")
            }
            .foregroundColor(Color(UIColor(named: "ButtonColor")!))
            .listRowBackground(Color.clear)
            
            HStack {
                Image(systemName: "envelope").imageScale(.large)
                Text("Profile").font(.headline)
            }.onTapGesture {
                print("Messages")
            }
            .foregroundColor(Color(UIColor(named: "ButtonColor")!))
            .listRowBackground(Color.clear)
            
            HStack {
                Image(systemName: "gear").imageScale(.large)
                Text("Settings").font(.headline)
            }.onTapGesture {
                print("Settings")
            }
            .foregroundColor(Color(UIColor(named: "ButtonColor")!))
            .listRowBackground(Color.clear)
        }
        .background(Color(UIColor(named: "BackgroundColor")!))
    }
}

/**
 View for the side menu
 */
struct SideMenuView: View {
    let width: CGFloat
    let isOpen: Bool
    let menuClose: () -> Void
    
    var body: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.black.opacity(0.1))
            .edgesIgnoringSafeArea([.top, .bottom])
            .opacity(self.isOpen ? 1.0 : 0.0)
            .animation(Animation.easeIn.delay(0.25))
            .onTapGesture {
                self.menuClose()
            }
            
            HStack {
                MenuContent()
                    .frame(width: self.width)
                    .offset(x: self.isOpen ? 0 : -self.width)
                    .animation(.default)
                
                Spacer()
                
            }
        }
        .background(Color.clear)
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
            Text("Hello World")
    }
}
