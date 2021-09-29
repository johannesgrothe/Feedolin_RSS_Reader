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
    
    /// Property that  indication of a scene’s operational state
    @Environment(\.scenePhase) var scene_phase
    
    /// colorScheme storage
    @AppStorage("appearance") var appearance: Appearance = .automatic
    
    /// Model Singleton
    @ObservedObject var model: Model = .shared

    init(){
        model.refreshFilter()
        model.isAppAlreadyLaunchedOnce()
        model.runAutoRefresh()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(appearance.colorScheme())
        }
    }
}
