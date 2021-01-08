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
    // Model Singleton
    @ObservedObject var model: Model = .shared
    @State private var show_add_feed_view = false
    
    var body: some View {
        
        /**
         displayes the collections and the feedproviders with their feeds
         */
        List {
            /**
             displayes the collections
             */
            Section(header: Text("Collections (\(model.collection_data.endIndex))")) {
                
                ForEach(model.collection_data) { item in
                    
                    Button(action: {
                        model.setFilterCollection(item)
                        model.refreshFilter()
                    }) {
                        HStack {
                            Image(systemName: "folder")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                            
                            Text(item.name)
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .listRowBackground(Color.clear)
            /**
             Show the feed providers
             */
            Section(header: Text("Newspaper")) {
                ForEach(model.feed_data) { feed_provider in
                    Button(action: {
                        model.setFilterFeedProvider(feed_provider)
                        model.refreshFilter()
                    }) {
                        HStack {
                            feed_provider.icon.img
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                                .cornerRadius(50)
                            Text(feed_provider.name)
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    /**
                     Show the feeds connected to the feed provider
                     */
                    ForEach(feed_provider.feeds) { feed in
                        
                        Button(action: {
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
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }                                .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .listRowBackground(Color.clear)
        }
        .frame(minWidth: 250)
        .listStyle(SidebarListStyle())
        .toolbar {
            Button(action: toggleSidebar, label: {
                Image(systemName: "sidebar.left")
            })
            
            Menu {
                /**
                 displayes all-button
                 */
                Button(action: {
                    model.setFilterAll()
                    model.refreshFilter()
                }) {
                    Label("All", systemImage: "infinity.circle.fill")
                        .frame(width: 22   , height: 22, alignment: .leading)
                        .scaledToFit()
                        .font(.headline)
                }
                /**
                 displayes booksmark-button
                 */
                Button(action: {
                    model.setFilterBookmarked()
                    model.refreshFilter()
                }) {
                    Label("Bookmarked",systemImage:"bookmark.circle.fill")
                        .frame(width: 22, height: 22, alignment: .leading)
                        .scaledToFit()
                        .font(.headline)
                }
                
            }
            label: {
                Label("Filter", systemImage: "line.horizontal.3.decrease.circle").imageScale(.large)
            }
            Button(action: {
                print("Add feed button clicked")
                self.show_add_feed_view.toggle()
            }) {
                Label("Add Feed", systemImage: "plus")
            }
        }
        .sheet(isPresented: self.$show_add_feed_view) {
            AddFeedView()
        }
    }
    
    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}
