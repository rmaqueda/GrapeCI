//
//  Json.swift
//  GrapeCITests
//
//  Created by Ricardo Maqueda Martinez on 04/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation

enum JsonFile: String {
    case BitBucketBuilds
    case BitBucketCommits
    case BitBucketEmptyPaginatedRepositories
    case BitBucketError
    case BitBucketPaginatedRepositories
    case BitBucketPullRequest
    case BitBucketTeam
    case BitBucketUser
    case GiHubCommits
    case GitHubBuilds
    case GitHubEmptyPaginatedRepositories
    case GitHubError
    case GitHubPaginatedRepositories
    case GitHubPullRequests
    case GitHubUser
}

class JSONUtil {

    func readData(filename: String) -> Data {
        guard let pathString = Bundle(for: type(of: self)).path(forResource: filename, ofType: "json") else {
            fatalError("\(filename).json not found")
        }

        guard let jsonString = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("Unable to convert \(filename).json to String")
        }

        guard let jsonData = jsonString.data(using: .utf8) else {
            fatalError("Unable to convert \(filename).json to Data")
        }

        return jsonData
    }

    func readData(jsonFile: JsonFile) -> Data {
        readData(filename: jsonFile.rawValue)
    }

    func read<T: Decodable>(filename: String, decoder: JSONDecoder? = nil) -> T? {
        let data = readData(filename: filename)
        var internalDecoder = JSONDecoder()
        if decoder != nil { internalDecoder = decoder! }

        return try? internalDecoder.decode(T.self, from: data)
    }

}
