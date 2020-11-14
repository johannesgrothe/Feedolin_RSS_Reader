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
    @ObservedObject var model: Model = .shared
    
    func createMenuItem() -> [MenuItem] {
        var menu_item_list: [MenuItem] = []
            
            for feed_provider in model.feed_data {
                var feed_provider_item = MenuItem(id: UUID(), name: feed_provider.name, image: feed_provider.icon.url, subMenuItems: [])
                
                for sub_feed in feed_provider.feeds {
                    let sub_feed_item = MenuItem(id: UUID(), name: sub_feed.name, image: nil, subMenuItems: nil)
                    feed_provider_item.subMenuItems?.append(sub_feed_item)
                }
                
                menu_item_list.append(feed_provider_item)
            }
        return menu_item_list
    }
    
    var body: some View {
        VStack {

//            Button(action: {
//                print("Show All Feeds Button pressed")
//            }) {
//                Label("All", systemImage: "newspaper")
//            }
//
//            Button(action: {
//                print("Saved Button pressed")
//            }) {
//                Label("Saved", systemImage: "tray.2")
//            }
                            
//            List(createMenuItem(), children: \.subMenuItems) { item in
            List(sampleMenuItems, children: \.subMenuItems) { item in
    //        List {
                HStack {
                    if item.image != nil {
                    Image(item.image!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    }
             
                    Text(item.name)
                        .font(.system(.title3, design: .rounded))
                        .bold()
                }
            }
        }
    }
}

struct MenuItem: Identifiable {
    var id = UUID()
    var name: String
    var image: String?
    var subMenuItems: [MenuItem]?
}

// Main menu items
let sampleMenuItems = [ MenuItem(name: "All", image: "newspaper", subMenuItems: nil),
                        MenuItem(name: "Grinders", image: "swift-mini", subMenuItems: nil),
                        MenuItem(name: "Other Equipment", image: "espresso-ep", subMenuItems: nil)
                    ]

// Main menu items
//let sampleMenuItems = [ MenuItem(name: "Espresso Machines", image: "linea-mini", subMenuItems: nil),
//                        MenuItem(name: "Grinders", image: "swift-mini", subMenuItems: nil),
//                        MenuItem(name: "Other Equipment", image: "espresso-ep", subMenuItems: nil)
//                    ]

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

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
