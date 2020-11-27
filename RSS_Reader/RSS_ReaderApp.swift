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
    
    /**Property that  indication of a scene’s operational state*/
    @Environment(\.scenePhase) var scene_phase
    
    /**Model Singleton*/
    @ObservedObject var model: Model = .shared
    
    init(){
        model.loadData()
        model.sortArticlesByShowInMain()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scene_phase) { current_scene_phase in
            switch current_scene_phase {
            case .background, .inactive:
                model.saveData()
            default: break
            }
        }
    }
}
