//
//  GitHubCommit.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 13/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation

struct GitHubCommit: Codable {
    let sha: String
    let nodeId: String
//    let commit: GitCommit
    let url: String
    let htmlUrl: String
    let commentsUrl: String
//    let author: GitHubComitAuthor
//    let committer: GitHubComitAuthor
//    let parents: [Parent]
//    let stats: Stats
//    let files: [File]

    enum CodingKeys: String, CodingKey {
        case sha
        case nodeId = "node_id"
        case url
        case htmlUrl = "html_url"
        case commentsUrl = "comments_url"
//        case commit = "commit"
//        case author = "author"
//        case committer = "committer"
//        case parents = "parents"
//        case stats = "stats"
//        case files = "files"
    }
}
