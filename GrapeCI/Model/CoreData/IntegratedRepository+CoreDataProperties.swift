//
//  IntegratedRepository+CoreDataProperties.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 23/03/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//
//

import Foundation
import CoreData

extension IntegratedRepository {
    @NSManaged public var identifier: String
    @NSManaged public var name: String
    @NSManaged public var fullName: String
    @NSManaged public var providerName: String
    @NSManaged public var defaultBranch: String
    @NSManaged public var workspaceID: String?
    @NSManaged public var pipeline: String?

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IntegratedRepository> {
        return NSFetchRequest<IntegratedRepository>(entityName: "IntegratedRepository")
    }

    func setProperties(repository: GitRepository) {
        precondition(repository.pipeline != nil, "The pipeline must not be empty")

        identifier = repository.identifier
        name = repository.name
        fullName = repository.fullName
        providerName = repository.provider.rawValue
        workspaceID = repository.workspaceID
        pipeline = repository.pipeline!
        defaultBranch = repository.defaultBranch.name
    }
}
