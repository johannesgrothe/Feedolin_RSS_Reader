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
    
    /**
     creates a list with feed items
     */
    func createFeedItem() -> [MenuItem] {
        var feed_item_list: [MenuItem] = []
        
        for feed_provider in model.feed_data {
            var feed_provider_item = MenuItem(id: UUID(), name: feed_provider.name, image: nil, subMenuItems: [])
            
            for sub_feed in feed_provider.feeds {
                let sub_feed_item = MenuItem(id: UUID(), name: sub_feed.name, image: nil, subMenuItems: nil)
                feed_provider_item.subMenuItems?.append(sub_feed_item)
            }
            
            feed_item_list.append(feed_provider_item)
        }
        return feed_item_list
    }
    
    //    /**
    //     creates a list with collection items
    //     */
    //    func createCollectionItem() -> [MenuItem] {
    //        var collection_item_list: [MenuItem] = []
    //
    //        for feed_provider in model.collection_data {
    //            let collection_provider_item = MenuItem(id: UUID(), name: feed_provider.name, image: nil, subMenuItems: [])
    //
    //            collection_item_list.append(collection_provider_item)
    //        }
    //        return collection_item_list
    //    }
    
    /**
     the view
     */
    var body: some View {
        /**
         displayes the content of the sidemenu
         */
        VStack {
            Text("Feeds")
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
            
            Button(action: {
                print("Filter: All")
                model.setFilterAll()
                model.refreshFilter()
            }) {
                
                /**
                 displayes booksmark- and all-button
                 */
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
                print("Filter: Bookmarked")
                model.setFilterBookmarked()
                model.refreshFilter()
            }) {
                HStack {
                    Image(systemName: "tray.2")
                        .font(.system(size: 20))
                        .padding()
                    Text("Bookmarked")
                        .font(.system(size: 20))
                    Spacer()
                }
                .foregroundColor(Color.black)
                .frame(minWidth: 0, maxWidth: .infinity)
            }
            
            List {
                Text("Collections (\(model.collection_data.endIndex))")
                    .frame(maxWidth: .infinity, alignment: .center)
                
                ForEach(model.collection_data) { item in
                    /**
                     displayes the collections
                     */
                    Button(action: {
                        print("Filter: Collection")
                        model.setFilterCollection(item)
                        model.refreshFilter()
                    }) {
                        HStack {
                            Image(systemName: "questionmark.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            
                            Text(item.name)
                                .font(.system(size: 20))//, design: .rounded))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                
                Text("Newspaper")
                    .frame(maxWidth: .infinity, alignment: .center)
                
                /**Show the feed providers*/
                ForEach(model.feed_data) { feed_provider in
                    
                    Button(action: {
                        print("Filter: Feed Provider")
                        model.setFilterFeedProvider(feed_provider)
                        model.refreshFilter()
                    }) {
                        HStack {
                            feed_provider.icon.img
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            Text(feed_provider.name)
                                .font(.system(size: 20))//, design: .rounded))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    /**Show the feeds connected to the feed provider*/
                    ForEach(feed_provider.feeds) { feed in
                        
                        Button(action: {
                            print("Filter: Feed")
                            model.setFilterFeed(feed)
                            model.refreshFilter()
                        }) {
                            HStack {
                                Spacer()
                                Text(feed.name)
                                    .font(.system(size: 20))//, design: .rounded))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        
                    }
                    
                }
            }
            
            
        }
    }
}

/**
 an menu item
 */
struct MenuItem: Identifiable {
    /**
     id of the menu item
     */
    var id = UUID()
    /**
     name of the menu item
     */
    var name: String
    /**
     of the menu item
     */
    var image: String?
    /**
     of the menu item
     */
    var subMenuItems: [MenuItem]?
}

/**
 View for the side menu
 */
struct SideMenuView: View {
    
    /**
     the width of the sidemenu
     */
    let width: CGFloat
    
    /**
     contain informations about the visibil status of the sidemenu
     */
    let isOpen: Bool
    
    /**
     closed the sidemenu
     */
    let menuClose: () -> Void
    
    /**
     contain also informations about the visibil status of the sidemenu
     */
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
        
        /**
         slides the sidemenu over the main view
         */
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



