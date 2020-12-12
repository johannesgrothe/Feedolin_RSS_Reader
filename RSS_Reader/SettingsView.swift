//
//  SettingsView.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 04.11.20.
//

import SwiftUI

struct SettingsView: View {
    /**Model singleton*/
    @ObservedObject var model: Model = .shared
    
    @State private var showingAlert = false
    
    var body: some View {
        List {
            NavigationLink(destination: FeedSettingsView()) {
                HStack {
                    Image(systemName: "newspaper").imageScale(.large)
                    Text("Feed Settings").font(.headline)
                }
            }
            .listRowBackground(Color.clear)
            NavigationLink(destination: CollectionSettingsView()) {
                HStack {
                    Image(systemName: "folder").imageScale(.large)
                    Text("Collection Settings").font(.headline)
                }
            }
            .listRowBackground(Color.clear)
            .navigationBarTitle("Settings")
            Button(action: {
                self.showingAlert = true
            }) {
                HStack{
                    //For the Reviwer an alternative image could be "trash"
                    Image(systemName: "doc.badge.gearshape").imageScale(.large)
                    Text("Factory Reset").font(.headline)
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Factory Reset"), message: Text("WARNING: This action will irreversible delete all Data!"), primaryButton: .default(Text("Okay"), action: {model.reset()}),secondaryButton: .cancel())
            }
            .listRowBackground(Color.clear)
            .navigationBarTitle("Settings")
        }
        .onAppear(perform: {
            UITableView.appearance().backgroundColor = .clear
            UITableViewCell.appearance().backgroundColor = .clear
        })
        .navigationBarTitle("Settings")
        .background(Color(UIColor(named: "BackgroundColor")!))
        .edgesIgnoringSafeArea(.bottom)
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
