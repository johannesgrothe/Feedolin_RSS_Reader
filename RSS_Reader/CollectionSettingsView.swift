//
//  CollectionSettingsView.swift
//  RSS_Reader
//
//  Created by Katharina Kühn on 19.11.20.
//

import SwiftUI

/**
 Root View for the Collections settings.
 Here you see a list of all collections.
 */
struct CollectionSettingsView: View {
    var body: some View {
        CollectionSettingsList()
            .navigationBarTitle("Collection Settings")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button(action: {
                            print("Add New Collection Button clicked.")
                        }) {
                            Label("Add Collection", systemImage: "plus")
                        }
                        
                        Button(action: {
                            print("Remove Collection Button clicked.")
                        }) {
                            Label("Remove Collection", systemImage: "trash")
                        }
                    }
                    label: {
                        Label("Edit", systemImage: "square.and.pencil").imageScale(.large)
                    }
                }
            }
    }
}

/**
 A List of all collections
 */
struct CollectionSettingsList: View {

    /**
     The model
     */
    @ObservedObject var model: Model = .shared
    
    var body: some View {
        List {
            ForEach(model.collection_data) { collection in
                NavigationLink(destination: CollectionDetailSettingsView(collection: collection)) {
                    Text(collection.name).font(.headline)
                }
            }
        .listRowBackground(Color.clear)
        }
        .onAppear(perform: {
            UITableView.appearance().backgroundColor = .clear
            UITableViewCell.appearance().backgroundColor = .clear
        })
        .background(Color(UIColor(named: "BackgroundColor")!))
        .edgesIgnoringSafeArea(.bottom)
    }
}

/**
 The detailed view of a specific collection
 Here you see a list of feeds contained in this collection
 */
struct CollectionDetailSettingsView: View {
    
    /**
     The collection that is displayed in the view
     */
    @ObservedObject var collection: Collection
    
    /**
    Model Singleton
     */
    @ObservedObject var model: Model = .shared
    
    /**
     indicates if the add feed view is shown or not
     */
    @State private var show_add_feed_view = false
    
    
    //line 92 is part of the workaround for back button bug
    @Environment(\.presentationMode) var presentationMode
    
    /**
     * ToDo: Add comment
     */
    @State private var editMode = EditMode.inactive

    
    @State private var editM = false
    
    @State private var presented_feed_list: [NewsFeed] = []
    
    
    /**
     * ToDo: Add comments
     */
    func fillFeedLis() {
        print("call fill feed list")
        if (editM) {
            self.presented_feed_list = []
            for feed_prov in model.feed_data {
                for feed in feed_prov.feeds {
                    self.presented_feed_list.append(feed)
                }
            }
        } else {
            self.presented_feed_list = collection.feed_list
        }
        
        
    }
    
    var body: some View {
        
        List {
            
            
            
            ForEach(presented_feed_list) { feed in
                // a row that contains the name of a feed, his parent token and icon
                HStack {
                    
                    feed.parent_feed!.icon.img
                        .resizable()
                        .frame(width: 25, height: 25)
                    Text("\(feed.parent_feed!.token) - \(feed.name)")//.font(.headline)
                    Spacer()
                    
                    if (editM) {
                        
                        if (checkBla(feed: feed)) {
                           
                            Button(action: {
                                print("Delete Feed from Collection Button clicked.")
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                            }
                        } else {
                            Button(action: {
                                print("Add Feed to Collection Button clicked.")
                                let result = collection.addFeed(new_feed: feed)
                                print(result)
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                            
                            
                    }
                    
                }
            }
            
//            .onChange(of: editM) { newValue in
//                fillFeedLis()
//            }

            
            
            .listRowBackground(Color.clear)
            
            
        
        }
        
            
        // enable edit
//        Toggle("Hide", isOn: $editM)
        .navigationBarItems(trailing:
            Button(action: {
                print("Edit btn clicked")
                if (editM) {
                    editM = false
                } else {
                    editM = true
                }
                fillFeedLis()
            }) {
                if (editM) {
                    Text("Done")
                } else {
                    Text("Edit")
                }
            })
        //
        
        .onAppear(perform: {
            UITableView.appearance().backgroundColor = .clear
            UITableViewCell.appearance().backgroundColor = .clear
            fillFeedLis()
        })
        .background(Color(UIColor(named: "BackgroundColor")!))
        .edgesIgnoringSafeArea(.bottom)
        .navigationTitle(collection.name)

        
    
    }
    
    /**
     * ToDo: Add comment
     */
    func checkBla(feed: NewsFeed) -> Bool {
        
        for coll_feed in collection.feed_list {
            if (coll_feed.id == feed.id) {
                return true
            }
        }
        return false
    }
    
    /**
     * ToDo: Add comment
     */
    private func onAdd() {
            print("add feed to coll btn pressed")
        }
    
    /**
     * ToDo: Add comment
     */
    func delete(at offsets: IndexSet) {
        print("delete feed from coll btn pressed")
    }
}

///**
// The View that displayes a List of all feeds from the model that are not in the collection yet.
// _Parameter collection:_ The collection to which one or more feeds should be added
// */
//struct AddFeedsToCollectionView: View {
//
//    @Environment(\.presentationMode) var presentationMode
//
//    /**
//     Model Singleton
//     */
//    @ObservedObject var model: Model = .shared
//
//    /**
//     The collection that is displayed in the view
//     */
//    @ObservedObject var collection: Collection
//
//    /**
//     indicates if the view is  loading or not
//     */
//    @State private var loading = false
//
//    var body: some View {
//        NavigationView {
//
//        List {
//            ForEach(getFeedsNotInCollection()) { feed in
//
//
//                Button(action: {
//                    let result = collection.addFeed(new_feed: feed)
//                    print(result)
//                }) {
//                    // a row that contains the name of a feed, his parent token and icon
//                    HStack {
//                        feed.parent_feed!.icon.img
//                            .resizable()
//                            .frame(width: 25, height: 25)
//                        Text("\(feed.parent_feed!.token) - \(feed.name)")//.font(.headline)
//                    }
//                }
//            }
//        .listRowBackground(Color.clear)
//
//        }.disabled(self.loading)
//        .blur(radius: self.loading ? 3 : 0)
//        .background(Color(UIColor(named: "BackgroundColor")!))
//        .edgesIgnoringSafeArea(.bottom)
//
//
//
//        .navigationBarTitle("Add Feeds", displayMode: .inline)
//        .navigationBarItems(
//            trailing:
//                Button(action: {
//                    print("save_btn pressed")
//                    self.presentationMode.wrappedValue.dismiss()
//                }) {
//                    Text("Save")
//                }
//        )}
//    }
//
//    /**
//     Returns a list of all feeds from the model which are not in this collection yet.
//     _return:_ List of NewsFeedProvider that are not in this collection
//     */
//    func getFeedsNotInCollection() -> [NewsFeed] {
//
//        let coll_feed_list = collection.feed_list
//
//        var feed_list: [NewsFeed] = []
//
//        for feed_provider in model.feed_data {
//            for feed in feed_provider.feeds {
//                feed_list.append(feed)
//            }
//        }
//
//        print( feed_list.filter({ item in !coll_feed_list.contains(where: { $0.id == item.id }) }) )
//        return feed_list.filter({ item in !coll_feed_list.contains(where: { $0.id == item.id }) })
//    }
//
//}

/**
 Previews
 */
struct CollectionSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionSettingsView()
    }
}

struct CollectionDetailSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let collection = Collection(name: "Coll")
        CollectionDetailSettingsView(collection: collection)
    }
}
