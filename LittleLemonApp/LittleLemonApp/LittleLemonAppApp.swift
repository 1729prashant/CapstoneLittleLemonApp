//
//  LittleLemonAppApp.swift
//  LittleLemonApp
//
//  Created by Prashant V Gaikar on 25/09/24.
//

import SwiftUI

@main
struct LittleLemonAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
