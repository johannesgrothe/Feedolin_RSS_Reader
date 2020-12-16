//
//  SettingsView.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 04.11.20.
//

import SwiftUI

struct SettingsView: View {
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
