//
//  GitHub.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 04/02/2020.
//  Copyright © 2020 Ricardo.Maqueda. All rights reserved.
//

import Cocoa
import OAuth2
import Combine

class GitHub: OAuth2DataLoader {
    let providerName: Provider = .gitHub
    var isLogged: Bool {
        oauth2.hasUnexpiredAccessToken()
    }

    let baseURL = Constants.gitHubAPI
    var user: GitUser?

    var token: String? {
        oauth2.accessToken
    }

    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    private let oauthConfig = OAuth2CodeGrant(settings: [
        "client_id": Constants.gitHubClientId,
        "client_secret": Constants.gitHubClientSecret,
        "authorize_uri": Constants.gitHubAutorize,
        "token_uri": Constants.gitHubToken,
        "scope": Constants.gitHubScope,
        "redirect_uris": Constants.gitHubRedirectURIs,
        "secret_in_body": true,
        "keychain_access_group": Constants.gitHubKeychainAccessGroup
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
        //oauth2.logger = OAuth2DebugLogger(.trace)
    }

    func authorize(in window: NSWindow) -> AnyPublisher<GitUser, Error> {
        return Future<GitUser, Error> { promise in
            self.oauth2.authorizeEmbedded(from: window) { _, error in
                if error == nil {
                    self.updateUser()
                        .sink(
                            receiveCompletion: { _ in print("GitHub login completed.") },
                            receiveValue: { user in
                                self.user = user
                                promise(.success(user)) })

                        .store(in: &self.subscriptions)
                } else {
                    print(error!.localizedDescription)
                    promise(.failure(error!))
                }
            }
        }.eraseToAnyPublisher()
    }

    func update() {
        updateUser()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { self.user = $0 })
            .store(in: &self.subscriptions)
    }

    func logout() {
        oauth2.forgetTokens()
        user = nil
        HTTPCookieStorage.shared.cookies?.forEach { HTTPCookieStorage.shared.deleteCookie($0) }
        print("GitHub logout completed.")
    }

    func handleRedirectURL(_ url: URL) {
        do {
            try oauth2.handleRedirectURL(url)
        } catch {
            print("Error handling redirect url \(error)")
        }
    }

    private func updateUser() -> AnyPublisher<GitUser, Error> {
        let url = baseURL.appendingPathComponent("/user")
        let req = oauth2.request(forURL: url)

        return Future<GitUser, Error> { promise in
            self.perform(request: req) { response in
                if let data = response.data,
                    let user = try? JSONDecoder().decode(GitHubUser.self, from: data) {
                    promise(.success(user))
                }
            }
        }.eraseToAnyPublisher()
    }

}
