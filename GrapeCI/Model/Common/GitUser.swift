//
//  GitUser.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 23/03/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation

protocol GitUser {
    var username: String { get }
    var displayName: String { get }
}
