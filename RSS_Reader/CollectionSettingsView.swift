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
     * name of a new collection the user wants to add
     */
    @State var new_coll_name: String = ""
    
    var body: some View {
        
        //    CollectionSettingsList()
        List {
            
            if (edit_mode) {
                
                /**
                 * Container for new collection input
                 */
                HStack {
                    /**
                     * Container for Textfield and clear-btn
                     */
                    HStack {
                        
                        // collection name text field
                        TextField("Add a new collection name...", text: self.$new_coll_name, onEditingChanged: { isEditing in
                        })
                        
                        // x Button
                        Button(action: {
                            print("Clear coll name TextField btn clicked.")
                            new_coll_name = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                                .opacity(new_coll_name == "" ? 0 : 1)
                        }
                    }
                    .padding(8)
                    .background(Color(.secondarySystemBackground))
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
            
            let sorted_collection_data = model.collection_data.sorted(by: { return $0.name < $1.name })
            
            ForEach(sorted_collection_data) { collection in
                
                if (edit_mode) {
                    
                    /**
                     * Container for list row in edit mode
                     */
                    HStack {
                        Text(collection.name).font(.headline)
                        
                        Spacer()
                        
                        Button(action: {
                            print("Delete Collection Button clicked.")
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
