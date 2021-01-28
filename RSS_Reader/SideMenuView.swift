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
    /// width of side menu
    let width: CGFloat
    /// boolean if side menu is shown
    @Binding var show_menu: Bool
    /// Model Singleton
    @ObservedObject var model: Model = .shared
    /// closed the sidemenu with animation
    let menu_close: () -> Void
    /// scale of all icons
    @AppStorage("image_style_int") var image_style_int: Int = ImageStyle.square_rounded.rawValue
    /// IconSize that indicates the size of every icon
    @AppStorage("image_size_int") var image_size_int: Int = ImageSize.medium.rawValue
    
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
                    }, label: {
                        DefaultListEntryView(sys_image: CustomSystemImage(image: .infinity, style: ImageStyle.init(rawValue: image_style_int)!, size: ImageSize.init(rawValue: image_size_int)!), text: "All", font: .headline)
                    })
                    .listRowBackground(Color.clear)
                    /**
                     displayes booksmark-button
                     */
                    Button(action: {
                        menu_close()
                        model.setFilterBookmarked()
                        model.refreshFilter()
                    }, label: {
                        DefaultListEntryView(sys_image: CustomSystemImage(image: .bookmark, style: ImageStyle.init(rawValue: image_style_int)!, size: ImageSize.init(rawValue: image_size_int)!), text: "Bookmarked", font: .headline)
                    })
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
                            }, label: {
                                DefaultListEntryView(sys_image: CustomSystemImage(image: .folder, style: ImageStyle.init(rawValue: image_style_int)!, size: ImageSize.init(rawValue: image_size_int)!), text: collection.name, font: .headline)
                            })
                        }
                        .listRowBackground(Color.clear)
                    }
                    
                    /**
                     displayes the feed providers
                     */
                    ForEach(model.feed_data) { feed_provider in
                        Section(header: Text(feed_provider.name)){
                            Button(action: {
                                menu_close()
                                model.setFilterFeedProvider(feed_provider)
                                model.refreshFilter()
                            }, label: {
                                DefaultListEntryView(image: CustomImage(image: feed_provider.icon.img, style: ImageStyle.init(rawValue: image_style_int)!, size: ImageSize.init(rawValue: image_size_int)!), text: feed_provider.name, font: .headline)
                            })
                            /**
                             displayes the feeds connected to the feed provider
                             */
                            ForEach(feed_provider.feeds) { feed in
                                Button(action: {
                                    menu_close()
                                    model.setFilterFeed(feed)
                                    model.refreshFilter()
                                }, label: {
                                    DefaultListEntryView(sys_image: CustomSystemImage(image: .circle_small, style: .nothing, size: .xxsmall), padding: ImageSize.init(rawValue: image_size_int)!.size.width*0.4, text: feed.name, font: .subheadline)
                                        
                                })
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                }
                .listStyle(SidebarListStyle())
                .defaultScreenLayout()
                .navigationBarTitle("Filter",displayMode: .inline)
            }
            .autoNavigationViewStyle()
            .frame(width: self.width)
            
        }
        .gesture(drag_left)
        
        return stack
    }
}
