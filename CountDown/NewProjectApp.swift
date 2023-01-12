//
//  NewProjectApp.swift
//  NewProject
//
//  Created by modi on 19/06/1444 AH.
//

import SwiftUI

@main
struct NewProjectApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
