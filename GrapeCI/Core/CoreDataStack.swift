//
//  CoreDataStack.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 21/12/2019.
//  Copyright © 2019 Ricardo.Maqueda. All rights reserved.
//

import Foundation
import Cocoa

class CoreDataStack: CoreDataProtocol {
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    var backgroundContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GrapeCI")
        container.loadPersistentStores(completionHandler: { details, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
            print("Database path: \(details.url?.path ?? "").")
        })
        return container
    }()

    func reset() {
        do {
            try persistentContainer.persistentStoreCoordinator.managedObjectModel.entities.forEach { (entity) in
                if let name = entity.name {
                    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: name)
                    let request = NSBatchDeleteRequest(fetchRequest: fetch)
                    try viewContext.execute(request)
                }
            }

            try viewContext.save()
            fatalError("The database was reset.")
        } catch {
            print("Error resenting the database: \(error.localizedDescription)")
        }
    }

}
