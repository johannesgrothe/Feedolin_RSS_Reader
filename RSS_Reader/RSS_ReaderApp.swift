//
//  RSS_ReaderApp.swift
//  RSS_Reader
//
//  Created by Emircan Duman on 29.10.20.
//

import SwiftUI

@main
struct RSS_ReaderApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
