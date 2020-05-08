//
//  GitrepositoryMock.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 14/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation
@testable import GrapeCI

extension GitRepository {

    static var mock: GitRepository {
        GitRepository(identifier: "identifier",
                      name: "name",
                      fullName: "fullName",
                      provider: .gitHub,
                      defaultBranch: GitBranch(name: "name"),
                      url: "url")
    }
}
