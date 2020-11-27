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
            .navigationTitle("Collection Settings")
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
 Here you see a list of feeds
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
    
    @State private var show_add_feed_view = false
    
    var body: some View {
        List {
            ForEach(collection.feed_list) { feed in
                Text(feed.name).font(.headline)
            }
            .listRowBackground(Color.clear)
        }
        .onAppear(perform: {
            UITableView.appearance().backgroundColor = .clear
            UITableViewCell.appearance().backgroundColor = .clear
        })
        .background(Color(UIColor(named: "BackgroundColor")!))
        .edgesIgnoringSafeArea(.bottom)
        .navigationTitle(collection.name)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button(action: {
                        print("Add Feed to Collection Button clicked.")
                        self.show_add_feed_view.toggle()
                    }) {
                        Label("Add Feed", systemImage: "plus")
                    }
                    
                    Button(action: {
                        print("Remove Feed from Collection Button clicked.")
                    }) {
                        Label("Remove Feed", systemImage: "trash")
                    }
                }
                label: {
                    Label("Edit", systemImage: "square.and.pencil").imageScale(.large)
                }
            }
        }.sheet(isPresented: self.$show_add_feed_view) {
            AddFeedsToCollectionView(collection: collection)
        }
    }
}

/**
 The View that displayes a List of all feeds from the model that are not in the collection yet.
 _Parameter collection:_ The collection to which one or more feeds should be added
 */
struct AddFeedsToCollectionView: View {
    @State private var text = ""
    @State private var loading = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var model: Model = .shared
    
    @ObservedObject var collection: Collection
    
    var body: some View {
        ZStack {
            List {
                ForEach(getFeedsNotInCollection()) { feed in
                    Text(feed.name).font(.headline)
                }
            .listRowBackground(Color.clear)
                
//            VStack {
//                Text("Add Feed").padding(.top, 10)

//                Button("Add Feed") {
//                    loading = true
//                    let _ = model.addFeed(url: text)
//                    loading = false
//                    self.presentationMode.wrappedValue.dismiss()
//                }
//                .padding()
//                .cornerRadius(8)
//                .accentColor(Color(UIColor(named: "ButtonColor")!))
//                Spacer()
            }.disabled(self.loading)
            .blur(radius: self.loading ? 3 : 0)
            .background(Color(UIColor(named: "BackgroundColor")!))
            .edgesIgnoringSafeArea(.bottom)
            VStack {
                Text("Loading...")
                ProgressView()
            }.disabled(self.loading)
            .opacity(self.loading ? 1 : 0)
        }
        
    }
    
    /**
     Returns a list of all feeds from the model which are not in this collection yet.
     _return:_ List of NewsFeedProvider that are not in this collection
     */
    func getFeedsNotInCollection() -> [NewsFeedProvider] {

        let feed_list = model.feed_data
        let coll_feed_list = collection.feed_list
        
        print( feed_list.filter({ item in !coll_feed_list.contains(where: { $0.id == item.id }) }) )
        return feed_list.filter({ item in !coll_feed_list.contains(where: { $0.id == item.id }) })
    }
    
}

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
        let collection = Collection(name: "Bla")
        CollectionDetailSettingsView(collection: collection)
    }
}
