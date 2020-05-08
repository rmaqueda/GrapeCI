//
//  LoggedProvider+CoreDataProperties.swift
//  GrapeCI
//
//  Created by Ricardo.Maqueda on 05/05/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//
//

import Foundation
import CoreData

extension LoggedProvider {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LoggedProvider> {
        return NSFetchRequest<LoggedProvider>(entityName: "LoggedProvider")
    }

    @NSManaged public var name: String?

}
