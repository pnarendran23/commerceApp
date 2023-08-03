//
//  CommerceAppApp.swift
//  CommerceApp
//
//  Created by Pradheep Narendran P on 03/08/23.
//

import SwiftUI

@main
struct CommerceAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ProductsView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
