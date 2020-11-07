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
                    Image(systemName: "person").imageScale(.large)
                    Text("Feed Settings").font(.headline)
                }
            }
            .navigationBarTitle("Settings")
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
