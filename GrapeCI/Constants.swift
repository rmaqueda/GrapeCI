//
//  Constants.swift
//  GrapeCI
//
//  Created by Ricardo.Maqueda on 02/05/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation

struct Constants {

    static var mainDirectory: String {
        #if DEBUG
        return NSHomeDirectory() + "/\(Constants.appName)/Debug"
        #else
        return NSHomeDirectory() + "/\(Constants.appName)"
        #endif
    }

    static let appName = "GrapeCI"

    static let pullInterval: TimeInterval = 300

    static let bitBucketAPI = URL(string: "https://api.bitbucket.org")!
    static let bitBucketClientId = Secrets.BitBucket.clientId
    static let bitBucketClientSecret = Secrets.BitBucket.clientSecret
    static let bitBucketScope = "pullrequest"
    static let bitBucketRedirectURIs = ["grapeci://oauth/bitbucket"]
    static let bitBucketAutorize = "https://bitbucket.org/site/oauth2/authorize"
    static let bitBucketToken = "https://bitbucket.org/site/oauth2/access_token"
    static let bitBucketKeychainAccessGroup = "BitBucketGroup"

    static let gitHubAPI = URL(string: "https://api.github.com")!
    static let gitHubClientId = Secrets.GitHub.clientId
    static let gitHubClientSecret = Secrets.GitHub.clientSecret
    static let gitHubScope = "user repo"
    static let gitHubRedirectURIs = ["grapeci://oauth/github"]
    static let gitHubAutorize = "https://github.com/login/oauth/authorize"
    static let gitHubToken = "https://github.com/login/oauth/access_token"
    static let gitHubKeychainAccessGroup = "GitHubGroup"

}
