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
    @State private var new_coll_name: String = ""
    
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
                        TextField("add_collection_textfield".localized, text: self.$new_coll_name, onEditingChanged: { isEditing in
                        })
                        
                        // x Button
                        Button(action: {
                            new_coll_name = ""
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                                .opacity(new_coll_name == "" ? 0 : 1)
                        })
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    .padding(8)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    
                    // Send Button for new collection
                    CDButton(action: {
                        if self.new_coll_name != "" {
                            print(self.new_coll_name)
                            let new_collection = Collection(name: self.new_coll_name)
                            _ = model.addCollection(new_collection)
                            self.new_coll_name = ""
                        } else {
                            print("Collection name is empty")
                        }
                    }, exits: false)
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
                        DefaultListEntryView(
                            sys_image: CustomSystemImage(image: .folder),
                            text: collection.name,
                            font: .headline)
                        
                        Spacer()
                        CDButton(action: {
                            model.collection_data.removeAll( where: { $0.id == collection.id })
                        }, exits: edit_mode)
                    }
                    
                } else {
                    NavigationLink(destination: CollectionDetailSettingsView(collection: collection)) {
                        DefaultListEntryView(
                            sys_image: CustomSystemImage(image: .folder),
                            text: collection.name,
                            font: .headline)
                    }
                }
                
            }
            .listRowBackground(Color.clear)
        }
        .listStyle(PlainListStyle())
        .defaultScreenLayout()
        .navigationBarTitle("Collection Settings", displayMode: .inline)
        .navigationBarItems(trailing:
                                ECButton(action: {}, is_editing: $edit_mode)
        )
    }
}
