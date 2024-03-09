//
//  CoreDataTodoListApp.swift
//  CoreDataTodoList
//
//  Created by Gaspar Dolcemascolo on 09/03/2024.
//

import SwiftUI

@main
struct CoreDataTodoListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
