//
//  CoreDataMock.swift
//  GrapeCITests
//
//  Created by Ricardo Maqueda Martinez on 04/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation
import CoreData
@testable import GrapeCI

class CoreDataMock: CoreDataProtocol {
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    var backgroundContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GrapeCI")

        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false

        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores(completionHandler: { _, error in
            precondition( description.type == NSInMemoryStoreType )
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()

//    func initStubs() {
//
//        func insertRepositories( name: String, finished: Bool ) -> IntegratedRepository? {
//            let obj = NSEntityDescription.insertNewObject(forEntityName: "IntegratedRepository",
//                                                          into: persistentContainer.viewContext)
//
//            obj.setValue(name, forKey: "name")
//            obj.setValue(finished, forKey: "finished")
//
//            return obj as? IntegratedRepository
//        }
//
//        // Create stubs here
//
//        do {
//            try persistentContainer.viewContext.save()
//        }  catch {
//            print("create fakes error \(error)")
//        }
//
//    }

}
