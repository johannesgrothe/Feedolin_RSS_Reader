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
