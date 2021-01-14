//
//  SideMenuView.swift
//  RSS_Reader
//
//  Updated by Kenanja Nuding on 12/23/20.
//
import SwiftUI

/**
 View for the side menu
 */
struct SideMenuView: View {
    // width
    let width: CGFloat
    // boolean if side menu is shown
    @Binding var show_menu: Bool
    
    // Model Singleton
    @ObservedObject var model: Model = .shared
    
    //closed the sidemenu with animation
    let menu_close: () -> Void
    
    var body: some View {
        // Drag gesture to close the side menu by swiping
        let drag_left = DragGesture().onEnded {
            if $0.translation.width < -100 {
                menu_close()
            }
        }
        /**
         displayes the content of the sidemenu
         */
        HStack{
            NavigationView {
                VStack{
                    /**
                     displayes all-button
                     */
                    Button(action: {
                        menu_close()
                        model.setFilterAll()
                        model.refreshFilter()
                    }) {
                        HStack {
                            Image(systemName: "infinity.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 22)
                            Text("all_filter".localized)
                                .font(.headline)
                            Spacer()
                        }
                        .padding([.vertical, .leading])
                    }
                    /**
                     displayes booksmark-button
                     */
                    Button(action: {
                        menu_close()
                        model.setFilterBookmarked()
                        model.refreshFilter()
                    }) {
                        HStack {
                            Image(systemName: "bookmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 22)
                            Text("bookmarked_filter".localized)
                                .font(.headline)
                            Spacer()
                        }
                        .padding([.leading, .vertical])
                    }
                    /**
                     displayes the collections and the feedproviders with their feeds
                     */
                    List {
                        /**
                         displayes the collections
                         */
                        Section(header: Text("\("collection_comp".localized) (\(model.collection_data.endIndex))")) {
                            
                            ForEach(model.collection_data) { item in
                                
                                Button(action: {
                                    menu_close()
                                    model.setFilterCollection(item)
                                    model.refreshFilter()
                                }) {
                                    HStack {
                                        Image(systemName: "folder.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 22, height: 22)
                                        
                                        Text(item.name)
                                            .font(.headline)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                        }
                        .listRowBackground(Color.clear)
                        /**
                         Show the feed providers
                         */
                        Section(header: Text("feed_comp".localized)) {
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
                                            .frame(width: 22, height: 22)
                                            .cornerRadius(100)
                                        Text(feed_provider.name)
                                            .font(.headline)
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
                                                .font(.subheadline)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                    .padding(.leading)
                                }
                            }
                        }
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(SidebarListStyle())
                    .onAppear(perform: {
                        UITableView.appearance().backgroundColor = .clear
                        UITableViewCell.appearance().backgroundColor = .clear
                        UITableView.appearance().showsVerticalScrollIndicator = false
                    })
                    
                }
                .navigationBarTitle("filter_comp".localized, displayMode: .inline)
                
                .background(Color(UIColor(named: "BackgroundColor")!))
                .accentColor(Color(UIColor(named: "ButtonColor")!))
                
                .edgesIgnoringSafeArea(.bottom)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .frame(width: self.width)
            
            Spacer()
            
            Rectangle()
                .edgesIgnoringSafeArea(.all)
                .foregroundColor(.black)
                .disabled(self.show_menu ? false : true)
                .opacity(self.show_menu ? 0.3 : 0)
                .onTapGesture {
                    self.menu_close()
                }
                
        }
        .gesture(drag_left)
    }
}
