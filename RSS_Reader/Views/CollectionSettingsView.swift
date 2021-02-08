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
        List {
            if (edit_mode) {
                // collection name text field for new collection input
                HStack {
                    // collection name text field
                    CustomTextfield(
                        placholder: "add_collection_textfield".localized,
                        text: self.$new_coll_name,
                        on_commit: {
                            if self.new_coll_name != "" {
                                print(self.new_coll_name)
                                model.collection_data.append(Collection(name: self.new_coll_name))
                                self.new_coll_name = ""
                            }
                        })
                    
                    // Send Button for new collection
                    CDButton(action: {
                        if self.new_coll_name != "" {
                            print(self.new_coll_name)
                            let new_collection = Collection(name: self.new_coll_name)
                            _ = model.addCollection(new_collection)
                            self.new_coll_name = ""
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
        .navigationBarTitle("coll_settings_title".localized, displayMode: .inline)
        .navigationBarItems(trailing:
                                ECButton(action: {}, is_editing: $edit_mode)
        )
    }
}
