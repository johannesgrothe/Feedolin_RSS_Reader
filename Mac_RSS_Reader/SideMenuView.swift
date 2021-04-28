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
    
    /**
     * indicates if the user is in edit_mode to add or remove collections
     */
    @State private var edit_mode = false
    
    /**
     * name of a new collection the user wants to add
     */
    @State private var new_coll_name: String = ""
    
    var body: some View {
        
        /**
         displayes the collections and the feedproviders with their feeds
         */
        List {
            
            /**
             displayes all-button
             */
            Button(action: {
                model.setFilterAll()
                model.refreshFilter()
            }) {
                HStack {
                    Image(systemName: "infinity.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                        .foregroundColor(Color("ButtonColor"))
                    Text("All")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            /**
             displayes booksmark-button
             */
            Button(action: {
                model.setFilterBookmarked()
                model.refreshFilter()
            }) {
                HStack {
                    Image(systemName: "bookmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                        .foregroundColor(Color("ButtonColor"))
                    Text("Bookmarked")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            /**
             displayes the collections
             */
            Section(header: Text("Collections (\(model.collection_data.endIndex))")) {
                if edit_mode{
                    /**
                     * Container for new collection input
                     */
                    HStack {
                        
                        // collection name text field
                        TextField("Collection Name", text: self.$new_coll_name, onEditingChanged: { isEditing in
                        })
                        .padding(8)
                        .cornerRadius(8)
                        
                        // Send Button for new collection
                        Button(action: {
                            print("Add Collection Button clicked.")
                            if self.new_coll_name != "" {
                                print(self.new_coll_name)
                                model.collection_data.append(Collection(name: self.new_coll_name))
                                self.new_coll_name = ""
                            } else {
                                print("Collection name is empty")
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    .listRowBackground(Color.clear)
                }
                ForEach(model.collection_data) { item in
                    CollectionButtonView(edit_mode: $edit_mode, collection: item)
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
                                .foregroundColor(Color("ButtonColor"))
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    /**
                     Show the feeds connected to the feed provider
                     */
                    ForEach(feed_provider.feeds) { feed in
                        FeedButtonView(edit_mode: $edit_mode, feed: feed)
                    }
                }
            }                                .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .listRowBackground(Color.clear)
        }
        .listStyle(SidebarListStyle())
        .toolbar{
            Spacer()
            Button(action: {
                self.edit_mode.toggle()
            }) {
                if edit_mode{
                    Text("Done")
                }
                else{
                    Text("Edit")
                }
            }
        }
    }
}

struct CollectionButtonView: View {
    @State private var showing_alert = false
    @Binding var edit_mode: Bool
    @ObservedObject var collection: Collection
    
    var body: some View {
        HStack {
            Button(action: {
                model.setFilterCollection(collection)
                model.refreshFilter()
            }) {
                HStack {
                    Image(systemName: "folder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color("ButtonColor"))
                    
                    Text(collection.name)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.leading)
            
            if edit_mode{
                Button(action:{
                    withAnimation {
                        self.showing_alert.toggle()
                    }
                }){
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                }
                .buttonStyle(BorderlessButtonStyle())
                .alert(isPresented: $showing_alert) {
                    Alert(title: Text("Removing Collection"), message: Text("WARNING: This action will irreversible delete the Collection: \(collection.name)"), primaryButton: .default(Text("Okay"), action: {
                        model.removeCollection(collection)
                        model.refreshFilter()
                    }),secondaryButton: .cancel())
                }
            }
            Spacer()
        }
    }
}

struct FeedButtonView: View {
    
    /**
     @showingAlert shows if alert is true*/
    @State private var showing_alert = false
    @Binding var edit_mode: Bool
    @ObservedObject var feed: NewsFeed
    
    var body: some View {
        HStack{
            Button(action: {
                model.setFilterFeed(feed)
                model.refreshFilter()
            }) {
                HStack {
                    Spacer()
                    Text(feed.name)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color("ButtonColor"))
                }
            }
            .padding(.leading)
            .buttonStyle(PlainButtonStyle())
            
            if edit_mode{
                Button(action:{
                    withAnimation {
                        self.showing_alert.toggle()
                    }
                }){
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                }
                .buttonStyle(BorderlessButtonStyle())
                .alert(isPresented: $showing_alert) {
                    Alert(title: Text("Removing Feed"), message: Text("WARNING: This action will irreversible delete the subscribed Feed and all of his Articles(Bookmarked Articles: \(feed.getAmountOfBookmarkedArticles())). If this is the last Feed, the Feed Provider will be deleted, too."), primaryButton: .default(Text("Okay"), action: {
                        model.removeFeed(feed)
                        model.refreshFilter()
                    }),secondaryButton: .cancel())
                }
            }
            Spacer()
        }
    }
}
