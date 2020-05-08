//
//  GitCommit.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 13/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation

struct GitCommit: Equatable {
    let sha: String
    var builds: [GitBuild] = []
}
