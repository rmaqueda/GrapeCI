//
//  GitPullRequest.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 13/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation

class GitPullRequest {
    let identifier: String
    let title: String
    let number: Int
    let origin: GitBranch
    var destination: GitBranch
    let link: String

    init (identifier: String,
          title: String,
          number: Int,
          origin: GitBranch,
          destination: GitBranch,
          link: String) {
        self.identifier = identifier
        self.title = title
        self.number = number
        self.origin = origin
        self.destination = destination
        self.link = link
    }

}
