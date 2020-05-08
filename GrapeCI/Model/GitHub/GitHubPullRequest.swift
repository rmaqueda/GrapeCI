//
//  GitHubPullRequest.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 10/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation

struct GitHubPullRequest: Codable {
    let identifier: Int
    let url: String
    let nodeId: String
    let htmlUrl: String
    let diffUrl: String
    let patchUrl: String
    let issueUrl: String
    let number: Int
    let state: String
    let locked: Bool
    let title: String
//    let user: User
    let body: String
    let createdAt: String
    let updatedAt: String
//    let closedAt: JSONNull?
//    let mergedAt: JSONNull?
    let mergeCommitSha: String
//    let assignee: JSONNull?
//    let assignees: [JSONAny]
//    let requestedReviewers: [JSONAny]
//    let requestedTeams: [JSONAny]
//    let labels: [JSONAny]
//    let milestone: JSONNull?
    let draft: Bool
    let commitsUrl: String
    let reviewCommentsUrl: String
    let reviewCommentUrl: String
    let commentsUrl: String
    let statusesUrl: String
    let head: GitHubBase
    let base: GitHubBase
    let links: GitHubLinks
    let authorAssociation: String

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case url
        case nodeId = "node_id"
        case htmlUrl = "html_url"
        case diffUrl = "diff_url"
        case patchUrl = "patch_url"
        case issueUrl = "issue_url"
        case number
        case state
        case locked
        case title
//        case user = "user"
        case body
        case createdAt = "created_at"
        case updatedAt = "updated_at"
//        case closedAt = "closed_at"
//        case mergedAt = "merged_at"
        case mergeCommitSha = "merge_commit_sha"
//        case assignee = "assignee"
//        case assignees = "assignees"
//        case requestedReviewers = "requested_reviewers"
//        case requestedTeams = "requested_teams"
//        case labels = "labels"
//        case milestone = "milestone"
        case draft
        case commitsUrl = "commits_url"
        case reviewCommentsUrl = "review_comments_url"
        case reviewCommentUrl = "review_comment_url"
        case commentsUrl = "comments_url"
        case statusesUrl = "statuses_url"
        case head
        case base
        case links = "_links"
        case authorAssociation = "author_association"
    }
}

struct GitHubBase: Codable {
    let label: String
    let ref: String
    let sha: String
//    let user: User
//    let repo: Repo

    enum CodingKeys: String, CodingKey {
        case label
        case ref
        case sha
//        case user = "user"
//        case repo = "repo"
    }
}

struct GitHubLinks: Codable {
    let linksSelf: GitHubComments
    let html: GitHubComments
    let issue: GitHubComments
    let comments: GitHubComments
    let reviewComments: GitHubComments
    let reviewComment: GitHubComments
    let commits: GitHubComments
    let statuses: GitHubComments

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html
        case issue
        case comments
        case reviewComments = "review_comments"
        case reviewComment = "review_comment"
        case commits
        case statuses
    }
}

struct GitHubComments: Codable {
    let href: String

    enum CodingKeys: String, CodingKey {
        case href
    }
}
