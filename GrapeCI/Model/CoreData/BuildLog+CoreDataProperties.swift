//
//  BuildLog+CoreDataProperties.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 24/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//
//

import Foundation
import CoreData

extension BuildLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BuildLog> {
        return NSFetchRequest<BuildLog>(entityName: "BuildLog")
    }

    @NSManaged public var providerName: String
    @NSManaged public var log: String
    @NSManaged public var identifier: String

}
