//
//  BitBucket.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 20/12/2019.
//  Copyright © 2019 Ricardo.Maqueda. All rights reserved.
//

import Cocoa
import OAuth2
import Combine

class BitBucket: OAuth2DataLoader {
    let providerName: Provider = .bitBucket
    var isLogged: Bool {
        oauth2.hasUnexpiredAccessToken()
    }
    let baseURL = Constants.bitBucketAPI
    var user: GitUser?
    var teams: [BitBucketTeam] = []

    var token: String? {
        oauth2.accessToken
    }

    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    private let oauthConfig = OAuth2CodeGrant(settings: [
        "client_id": Constants.bitBucketClientId,
        "client_secret": Constants.bitBucketClientSecret,
        "authorize_uri": Constants.bitBucketAutorize,
        "token_uri": Constants.bitBucketToken,
        "scope": Constants.bitBucketScope,
        "redirect_uris": Constants.bitBucketRedirectURIs,
        "keychain_access_group": Constants.bitBucketKeychainAccessGroup
    ])

    private var subscriptions = Set<AnyCancellable>()

    init() {
        super.init(oauth2: oauthConfig)

        alsoIntercept403 = true
        oauth2.authConfig.authorizeEmbedded = true
        oauth2.authConfig.ui.showCancelButton = true
        oauth2.authConfig.ui.useAuthenticationSession = true
        oauth2.authConfig.authorizeEmbeddedAutoDismiss = true
        oauth2.clientConfig.secretInBody = true
        oauth2.clientConfig.accessTokenAssumeUnexpired = false
        oauth2.logger = OAuth2DebugLogger(.trace)
    }

    @discardableResult
    func authorize(in window: NSWindow) -> AnyPublisher<GitUser, Error> {
        Future<GitUser, Error> { promise in
            self.oauth2.authorizeEmbedded(from: window) { _, error in
                if error == nil {
                    self.updateUser().zip(self.updateTeams())
                        .sink(
                            receiveCompletion: { _ in print("BitBucket login completed.") },
                            receiveValue: { (user, teams) in
                                self.user = user
                                self.teams = teams
                                promise(.success(user))
                        })
                        .store(in: &self.subscriptions)

                } else {
                    print(error!.localizedDescription)
                    promise(.failure(error!))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func update() {
        updateUser()
            .zip(updateTeams())
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { (user, teams) in
                    self.user = user
                    self.teams = teams
            })
            .store(in: &self.subscriptions)
    }

    func logout() {
        oauth2.forgetTokens()
        user = nil
        teams = []
        HTTPCookieStorage.shared.cookies?.forEach { HTTPCookieStorage.shared.deleteCookie($0) }
        print("BitBacket logout completed.")
    }

    func handleRedirectURL(_ url: URL) {
        do {
            try oauth2.handleRedirectURL(url)
        } catch {
            print("Error handling redirect url \(error)")
        }
    }

    private func updateUser() -> AnyPublisher<GitUser, Error> {
        let url = baseURL.appendingPathComponent("/2.0/user")
        let request = oauth2.request(forURL: url)

        return Future<GitUser, Error> { promise in
            self.perform(request: request) { response in
                if let data = response.data {
                    if let user = try? JSONDecoder().decode(BitBucketUser.self, from: data) {
                        promise(.success(user))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }

    private func updateTeams() -> AnyPublisher<[BitBucketTeam], Error> {
        Future<[BitBucketTeam], Error> { promise in
            let url = self.baseURL.appendingPathComponent("/2.0/user/permissions/teams")
            let request = self.oauth2.request(forURL: url)

            self.perform(request: request) { response in
                if let data = response.data,
                    let teamsPaginated = try? JSONDecoder().decode(BitBucketPaginated<BitBucketTeamInfo>.self,
                                                                   from: data) {
                    promise(.success(teamsPaginated.items.map { $0.team }))
                }
            }
        }.eraseToAnyPublisher()
    }

}
