//
//  CollectionSettingsView.swift
//  RSS_Reader
//
//  Created by Katharina Kühn on 19.11.20.
//

import SwiftUI

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
 ToDo
 */
struct CollectionSettingsList: View {
    
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


struct CollectionDetailSettingsView: View {
    
    // ToDo: comment
    @ObservedObject var collection: Collection
    
    var body: some View {
        List {
            ForEach(collection.feed_list) { feed in
                Text(feed.name).font(.headline)
            }
            .listRowBackground(Color.clear)
            
            Button(action: {
                print("Add New Collection Button clicked.")
            }) {
                Label("Add Collection", systemImage: "plus")
                    .frame(maxWidth: .infinity, alignment: .center)
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



struct CollectionSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionSettingsView()
    }
}

struct CollectionDetailSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionSettingsView()
    }
}
