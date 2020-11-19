//
//  CollectionSettingsView.swift
//  RSS_Reader
//
//  Created by Katharina Kühn on 19.11.20.
//

import SwiftUI

struct CollectionSettingsView: View {
    var body: some View {
        Text("Hello, Collection Seetings View!")
        CollectionSettingsList()
            .navigationTitle("Collection Settings")
    }
}

/**
 ToDo
 */
struct CollectionSettingsList: View {
    
    @ObservedObject var model: Model = .shared
    
    var body: some View {
        List {
            Text("Deine Muddaaa!")
        .listRowBackground(Color.clear)
        }
        .onAppear(perform: {
            UITableView.appearance().backgroundColor = .clear
            UITableViewCell.appearance().backgroundColor = .clear
        })
        .background(Color(UIColor(named: "BackgroundColor")!))
        .edgesIgnoringSafeArea(.bottom)
    }
}






struct CollectionSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionSettingsView()
    }
}
