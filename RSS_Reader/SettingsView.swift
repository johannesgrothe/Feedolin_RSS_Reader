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
    
    /**Boolean that shows an alert if true*/
    @State private var showingAlert = false
    
    /**Boolean that show if aurto_refresh is on and saves at coredata*/
    @AppStorage("auto_refresh") private var auto_refresh: Bool = true
    
    var body: some View {
        List {
            /** Calling FeedSettingsView()*/
            NavigationLink(destination: FeedSettingsView()) {
                HStack {
                    Image(systemName: "newspaper").imageScale(.large)
                    Text("Feed Settings").font(.headline)
                }
            }
            .listRowBackground(Color.clear)
            
            /**Calling CollectionSettingsView()*/
            NavigationLink(destination: CollectionSettingsView()) {
                HStack {
                    Image(systemName: "folder").imageScale(.large)
                    Text("Collection Settings").font(.headline)
                }
            }
            .listRowBackground(Color.clear)
            
            /**Button to reset the App to default*/
            Button(action: {
                self.showingAlert = true
            }) {
                HStack{
                    //For the Reviwer an alternative image could be "trash"
                    Image(systemName: "doc.badge.gearshape").imageScale(.large)
                    Text("Reset App").font(.headline)
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("App Reset"), message: Text("WARNING: This action will irreversible delete all Data!"), primaryButton: .default(Text("Okay"), action: {model.reset()}),secondaryButton: .cancel())
            }
            .listRowBackground(Color.clear)
            
            /**ToggleButton that toogles the value of @auto_refresh*/
            HStack{
                Toggle(isOn: $auto_refresh){
                    Image(systemName: "arrow.clockwise").imageScale(.large)
                    Text("Auto Refresh").font(.headline)
                }
                .onChange(of: auto_refresh){ _ in
                    model.runAutoRefresh()
                }
            }
            .listRowBackground(Color.clear)
        }
        .onAppear(perform: {
            UITableView.appearance().backgroundColor = .clear
            UITableViewCell.appearance().backgroundColor = .clear
        })
        .listStyle(PlainListStyle())
        .navigationBarTitle("Settings", displayMode: .inline)
        .background(Color("BackgroundColor"))
        .edgesIgnoringSafeArea(.bottom)
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
