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
    
    init() {
            UITableView.appearance().backgroundColor = .clear
            UITableViewCell.appearance().backgroundColor = .clear
    }
    
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

            Text("Feeds")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
//                    .multilineTextAlignment(.leading)
            
            Button(action: {
                print("Show All Feeds Button pressed")
            }) {
//                Label("All", systemImage: "newspaper")
                
                HStack {
                        Image(systemName: "newspaper")
                            .font(.title)
                            .padding()
                        Text("All")
                            .font(.title)
                        Spacer()
                    }
                .background(Color("LightGreen"))
                .frame(minWidth: 0, maxWidth: .infinity)
            }

            Button(action: {
                print("Saved Button pressed")
            }) {
                HStack {
                        Image(systemName: "tray.2")
                            .font(.title)
                            .padding()
                        Text("Saved")
                            .font(.title)
                        Spacer()
                    }
                .background(Color("LightGreen"))
                .frame(minWidth: 0, maxWidth: .infinity)
            }
                            
            List(createMenuItem(), children: \.subMenuItems) { item in
//            List(sampleMenuItems, children: \.subMenuItems) { item in
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
                    Spacer()
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


/**
 ###########
 
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
     
     init() {
             UITableView.appearance().backgroundColor = .clear
             UITableViewCell.appearance().backgroundColor = .clear
     }
     
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

             Text("Feeds")
                 .frame(maxWidth: .infinity, alignment: .leading)
                 .padding()
             
             Button(action: {
                 print("Show All Feeds Button pressed")
             }) {
                 
             HStack {
                     Image(systemName: "newspaper")
                         .font(.system(size: 20))
                         .padding()
                     Text("All")
                         .font(.system(size: 20))
                     Spacer()
                 }
                 .foregroundColor(Color.black)
                 .frame(minWidth: 0, maxWidth: .infinity)
             }

             Button(action: {
                 print("Saved Button pressed")
             }) {
                 HStack {
                         Image(systemName: "tray.2")
                             .font(.system(size: 20))
                             .padding()
                         Text("Saved")
                             .font(.system(size: 20))
                         Spacer()
                     }
                 .foregroundColor(Color.black)
                 .frame(minWidth: 0, maxWidth: .infinity)
             }
             
             Text("Collections")
                 .frame(maxWidth: .infinity, alignment: .leading)
                 .padding()
             
             //ToDo: Add here collections logic
             
             Text("Newspaper")
                 .frame(maxWidth: .infinity, alignment: .leading)
                 .padding()
             
             List(createMenuItem(), children: \.subMenuItems) { item in
                 HStack {
                     
                     if item.image != nil && item.image != "" {
                         Image(item.image!)
                             .resizable()
                             .scaledToFit()
                             .frame(width: 20, height: 20)
                     }
                     else {
                         Image(systemName: "questionmark.circle")
                             .resizable()
                             .scaledToFit()
                             .frame(width: 20, height: 20)
                     }
              
                     Text(item.name)
                         .font(.system(size: 20))//, design: .rounded))
                         .frame(maxWidth: .infinity, alignment: .leading)
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

 /**
  View for the side menu
  */
 struct SideMenuView: View {
     let width: CGFloat
     let isOpen: Bool
     let menuClose: () -> Void
     
     @State var showMenu: Bool = true
     
     var body: some View {
         
         let drag = DragGesture()
                     .onEnded {
                         if $0.translation.width < -100 {
                             withAnimation {
                                 self.showMenu = false
                                 self.menuClose()
                             }
                         }
                     }
         
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
             .gesture(drag) /***/
             
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

 //struct SideMenuView_Previews: PreviewProvider {
 //    static var previews: some View {
 //        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
 //    }
 //}

 
 
 */
