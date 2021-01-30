//
//  CollectionSettingsView.swift
//  RSS_Reader
//
//  Created by Katharina Kühn on 19.11.20.
//

import SwiftUI

/**
 * Root View for the Collections settings.
 * Here you see a list of all collections.
 */
struct CollectionSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    /**
     @showingAlert shows if alert is true*/
    @State private var showing_alert = false
    /**
     * The model
     */
    @ObservedObject var model: Model = .shared
    
    /**
     * name of a new collection the user wants to add
     */
    @State private var new_coll_name: String = ""
    
    var body: some View {
        
        NavigationView{
            VStack{
                List {
                    ForEach(model.collection_data.sorted(by: { return $0.name < $1.name })) { collection in
                        NavigationLink(destination: CollectionDetailSettingsView(collection: collection)) {
                            Text(collection.name).font(.headline)
                        }
                    }
                }
            }
        }
    }
}
