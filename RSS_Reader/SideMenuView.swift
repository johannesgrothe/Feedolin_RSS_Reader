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
    
    var imageScale: CGFloat = 26
    
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
        let stack = HStack{
            NavigationView {
                /**
                 displayes the hole sidemenu
                 */
                List {
                    /**
                     displayes all-button
                     */
                    Button(action: {
                        menu_close()
                        model.setFilterAll()
                        model.refreshFilter()
                    }) {
                        DefaultListEntryView(imageName: "infinity.circle", imageScale: imageScale, text: "All", font: .headline)
                    }
                    .listRowBackground(Color.clear)
                    /**
                     displayes booksmark-button
                     */
                    Button(action: {
                        menu_close()
                        model.setFilterBookmarked()
                        model.refreshFilter()
                    }) {
                        DefaultListEntryView(imageName: "bookmark.circle", imageScale: imageScale, text: "Bookmarked", font: .headline)
                    }
                    .listRowBackground(Color.clear)
                    /**
                     displayes the collections
                     */
                    Section(header: Text("Collections (\(model.collection_data.endIndex))")) {
                        
                        ForEach(model.collection_data) { collection in
                            Button(action: {
                                menu_close()
                                model.setFilterCollection(collection)
                                model.refreshFilter()
                            }) {
                                DefaultListEntryView(imageName: "folder.circle", imageScale: imageScale, text: collection.name, font: .headline)
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                    /**
                     displayes the feed providers
                     */
                    ForEach(model.feed_data) { feed_provider in
                        Section(header: Text(feed_provider.name)){
                            Button(action: {
                                menu_close()
                                model.setFilterFeedProvider(feed_provider)
                                model.refreshFilter()
                            }) {
                                DefaultListEntryView(image: feed_provider.icon.img, imageCornerRadius: 100, imageScale: imageScale, text: feed_provider.name, font: .headline)
                            }
                            /**
                             displayes the feeds connected to the feed provider
                             */
                            ForEach(feed_provider.feeds) { feed in
                                Button(action: {
                                    menu_close()
                                    model.setFilterFeed(feed)
                                    model.refreshFilter()
                                }) {
                                    DefaultListEntryView(imageName: "circlebadge", imageScale: imageScale/2, imagePadding: imageScale/4.7, text: feed.name, font: .subheadline)
                                }
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
                .navigationBarTitle("Filter",displayMode: .inline)
                
                .background(Color(UIColor(named: "BackgroundColor")!))
                .accentColor(Color(UIColor(named: "ButtonColor")!))
                
                .edgesIgnoringSafeArea(.bottom)
            }
            .autoNavigationViewStyle()
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
        
        return stack
    }
}
