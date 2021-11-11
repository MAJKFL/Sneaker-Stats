//
//  SneakerStats_withCoreDataApp.swift
//  SneakerStats-withCoreData
//
//  Created by Kuba Florek on 05/07/2020.
//

import SwiftUI
import CoreData

@main
struct SneakerStats: App {
    let context = PersistentCloudKitContainer.persistentContainer.viewContext
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, context)
        }
    }
}
