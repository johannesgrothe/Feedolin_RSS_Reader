//
//  RSS_ReaderApp.swift
//  RSS_Reader
//
//  Created by Emircan Duman on 29.10.20.
//

import SwiftUI
import BackgroundTasks

@main
struct RSS_ReaderApp: App {
    let persistenceController = PersistenceController.shared
    
    /**Property that  indication of a scene’s operational state*/
    @Environment(\.scenePhase) var scene_phase
    
    /**Model Singleton*/
    @ObservedObject var model: Model = .shared

    init() {
        model.loadData()
        model.refreshFilter()
        model.isAppAlreadyLaunchedOnce()
        model.runAutoRefresh()
        
        // MARK: Registering Launch Handlers for Tasks
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "de.proj-nrssa-beuth.backgroundFetch", using: nil) { task in
            // Downcast the parameter to an app refresh task as this identifier is used for a refresh request.
            handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        
        scheduleAppRefresh()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

func scheduleAppRefresh() {
    let request = BGAppRefreshTaskRequest(identifier: "de.proj-nrssa-beuth.backgroundFetch")
    request.earliestBeginDate = Date(timeIntervalSinceNow: 3 * 60 * 60) // Fetch no earlier than 15 minutes from now
    
    do {
        try BGTaskScheduler.shared.submit(request)
        print("App refresh scheduled")
    } catch {
        print("Could not schedule app refresh: \(error)")
    }
}

// Fetch the latest feed entries from server.
func handleAppRefresh(task: BGAppRefreshTask) {
    print("Background refresh task is beeing executed")
    
    scheduleAppRefresh()
    
    let model: Model = .shared
    
    model.fetchFeeds()
    
    task.expirationHandler = {
        // After all operations are cancelled, the completion block below is called to set the task to complete.
        print("Background task got cancelled")
    }

    task.setTaskCompleted(success: true)
}
