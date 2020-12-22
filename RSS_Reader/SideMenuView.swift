import SwiftUI

/**
 View for the side menu
 */
struct SideMenuView: View {
    // boolean if side menu is shown
    @Binding var show_menu : Bool
    // Model Singleton
    @ObservedObject var model: Model = .shared
    
    //closed the sidemenu with animation
    let menu_close: () -> Void
    
    var body: some View {
        /**
         displayes the content of the sidemenu
         */
        HStack{
            VStack{
                Text("Feeds")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                
                Button(action: {
                    menu_close()
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
                    .frame(minWidth: 0, maxWidth: .infinity)
                }
                
                Button(action: {
                    menu_close()
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
                    .frame(minWidth: 0, maxWidth: .infinity)
                }
                
                List {
                    /**
                     displayes the collections
                     */
                    Section(header: Text("Collections (\(model.collection_data.endIndex))")) {
                        
                        ForEach(model.collection_data) { item in
                            
                            Button(action: {
                                menu_close()
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
                    }
                    /**
                     Show the feed providers
                     */
                    Section(header: Text("Newspaper")) {
                        ForEach(model.feed_data) { feed_provider in
                            Button(action: {
                                menu_close()
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
                            
                            /**
                             Show the feeds connected to the feed provider
                             */
                            ForEach(feed_provider.feeds) { feed in
                                
                                Button(action: {
                                    menu_close()
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
                                .padding(.leading)
                            }
                        }
                    }
                }
                .onAppear(perform: {
                    UITableView.appearance().backgroundColor = .clear
                    UITableViewCell.appearance().backgroundColor = .clear
                })
//                .onDisappear(perform: {
//                    UITableView.appearance().backgroundColor = .clear
//                    UITableViewCell.appearance().backgroundColor = .clear
//                })
                .listStyle(SidebarListStyle())
                
            }
            .frame(width: 270)
            
            Spacer()
            
        }
        .background(Color(UIColor(named: "BackgroundColor")!))
        .edgesIgnoringSafeArea([.bottom, .top])
        .foregroundColor(.black)
        .accentColor(Color(UIColor(named: "ButtonColor")!))
    }
}
