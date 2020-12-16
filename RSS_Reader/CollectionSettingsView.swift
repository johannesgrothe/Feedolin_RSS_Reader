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
    
    /**
     * The model
     */
    @ObservedObject var model: Model = .shared
    
    /**
     * indicates if the user is in edit_mode to add or remove collections
     */
    @State private var edit_mode = false
    
    /**
     * ToDo: Add comment
     */
    @State var new_coll_name: String = "NewCollection"
    
    var body: some View {

//    CollectionSettingsList()
        List {
        
            if (edit_mode) {
                HStack {
                    TextField("Add a new collection name...", text: $new_coll_name)
                    
                    Spacer()
                    Button(action: {
                        print("Add Collection Button clicked.")
                        model.collection_data.append(Collection(name: new_coll_name))
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                    }
                    
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .listRowBackground(Color.clear)
            }
            
            ForEach(model.collection_data) { collection in
                
                if (edit_mode) {
                
                    /**
                     * ToDo: Add comment
                     */
                    HStack {
                        Text(collection.name).font(.headline)
                        
                        Spacer()
                        
                        Button(action: {
                            print("Delete Collection Button clicked.")
                            // ToDo: call delete coll methode
                            model.collection_data.removeAll( where: { $0.id == collection.id })
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                    
                } else {
                    NavigationLink(destination: CollectionDetailSettingsView(collection: collection)) {
                        Text(collection.name).font(.headline)
                    }
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
        .navigationTitle("Collection Settings")
        .navigationBarItems(trailing:
            Button(action: {
                print("Edit collection btn clicked")
                if (edit_mode) {
                    edit_mode = false
                } else {
                    edit_mode = true
                }
            }) {
                if (edit_mode) {
                    Text("Done")
                } else {
                    Text("Edit")
                }
            })
    }
}


///**
// * Displayes the List of all collections
// */
//struct CollectionSettingsList: View {
//
//    /**
//     * The model
//     */
//    @ObservedObject var model: Model = .shared
//    
//    var body: some View {
//        List {
//            ForEach(model.collection_data) { collection in
//                NavigationLink(destination: CollectionDetailSettingsView(collection: collection)) {
//                    Text(collection.name).font(.headline)
//                }
//            }
//        .listRowBackground(Color.clear)
//        }
//        .onAppear(perform: {
//            UITableView.appearance().backgroundColor = .clear
//            UITableViewCell.appearance().backgroundColor = .clear
//        })
//        .background(Color(UIColor(named: "BackgroundColor")!))
//        .edgesIgnoringSafeArea(.bottom)
//    }
//}
