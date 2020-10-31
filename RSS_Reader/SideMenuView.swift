//
//  SideMenuView.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 31.10.20.
//

import SwiftUI


//HStack {
//    Image(systemName: "person")
//    Text("Profile")
//}.onTapGesture {
//    print("My Profile")
//}


// Content of the Menu
struct MenuContent: View {
    var body: some View {
        List {
            HStack {
                Image(systemName: "person").imageScale(.large)
                Text("Profile").font(.headline)
            }.onTapGesture {
                print("My Profile")
            }
            
            HStack {
                Image(systemName: "envelope").imageScale(.large)
                Text("Profile").font(.headline)
            }.onTapGesture {
                print("Messages")
            }
            
            HStack {
                Image(systemName: "gear").imageScale(.large)
                Text("Settings").font(.headline)
            }.onTapGesture {
                print("Settings")
            }
            
//            Text("My Profile").onTapGesture {
//                print("My Profile")
//            }
//            Text("Posts").onTapGesture {
//                print("Posts")
//            }
//            Text("Logout").onTapGesture {
//                print("Logout")
//            }
        }
    }
}

// View for the Side Menu
struct SideMenuView: View {
    let width: CGFloat
    let isOpen: Bool
    let menuClose: () -> Void
    
    var body: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.gray.opacity(0.1))
            .opacity(self.isOpen ? 1.0 : 0.0)
            .animation(Animation.easeIn.delay(0.25))
            .onTapGesture {
                self.menuClose()
            }
            
            HStack {
                MenuContent()
                    .frame(width: self.width)
                    .background(Color.white)
                    .offset(x: self.isOpen ? 0 : -self.width)
                    .animation(.default)
                
                Spacer()
                
            }
        }
    }
}
