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
    
    @State private var show_add_collection_view = false
    
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
                HStack{
                    Button(action: {
                        print("Add Collection button clicked")
                        self.show_add_collection_view.toggle()
                        
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(Color.red)
                            .imageScale(.large)
                            .cornerRadius(0)
                    }
                }
  
                .sheet(isPresented: self.$show_add_collection_view) {
                    AddCollectionView()
                }
            }
        }
    }
}

struct AddCollectionView: View {
    @State private var new_coll_name: String = ""
    @State private var loading = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View{
        VStack {
            HStack{
                Text("Add Collection").padding(.top, 10)
                // collection name text field
                TextField("Add a new collection name...", text: self.$new_coll_name, onEditingChanged: { isEditing in
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                // x Button
                Button(action: {
                    print("Clear coll name TextField btn clicked.")
                    new_coll_name = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .opacity(new_coll_name == "" ? 0 : 1)
                }
                .buttonStyle(BorderlessButtonStyle())
                Spacer()
            }
            .padding(15.0)
            HStack{
                Button("Add Collection") {
                    if self.new_coll_name != "" {
                        loading = true
                        print(self.new_coll_name)
                        model.collection_data.append(Collection(name: self.new_coll_name))
                        loading = false
                        self.new_coll_name = ""
                        self.presentationMode.wrappedValue.dismiss()
                    } else {
                        print("Collection name is empty")
                    }
                }
                .padding(3)
                .cornerRadius(8)
                .accentColor(Color("ButtonColor"))
                Button("Cancel"){
                    self.presentationMode.wrappedValue.dismiss()
                }
                .padding(3)
                .cornerRadius(8)
                .accentColor(Color("ButtonColor"))
                
            }
            Spacer()
        }
        .padding(2)
        .background(Color(.windowBackgroundColor))
        .cornerRadius(4)
        .frame(minWidth: 250)
    }
}
