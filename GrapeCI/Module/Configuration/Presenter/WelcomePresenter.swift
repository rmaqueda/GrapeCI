//
//  WelcomePresenter.swift
//  GrapeCI
//
//  Created by Ricardo.Maqueda on 27/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation
import Combine

final class WelcomeViewModel: ObservableObject {
    @Published var isBitbucketAuthenticated = false
    @Published var isGitHubAutheticated = false
}

class WelcomePresenter {
    private(set) var viewModel: WelcomeViewModel
    private let interactor: FetchUserInteractor
    private var cancelables = Set<AnyCancellable>()

    init(interactor: FetchUserInteractor) {
        self.interactor = interactor
        self.viewModel = WelcomeViewModel()

        self.viewModel.isGitHubAutheticated = interactor.isAuthenticated(for: .gitHub)
        self.viewModel.isBitbucketAuthenticated = interactor.isAuthenticated(for: .bitBucket)

        subcribeToggleChanges()
    }

    func subcribeToggleChanges() {
        viewModel.$isBitbucketAuthenticated
            .filter { $0 != self.viewModel.isBitbucketAuthenticated }
            .map { self.toggleChange(value: $0, for: .bitBucket) }
            .sink {}
            .store(in: &cancelables)

        viewModel.$isGitHubAutheticated
            .filter { $0 != self.viewModel.isGitHubAutheticated }
            .map { self.toggleChange(value: $0, for: .gitHub) }
            .sink {}
            .store(in: &cancelables)
    }

    private func toggleChange(value: Bool, for provider: Provider) {
        if value {
            authenticate(for: provider)
        } else {
            logout(for: provider)
        }
    }

    private func authenticate(for provider: Provider) {
        interactor.authenticate(for: provider)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { _ in })
            .store(in: &cancelables)
    }

    private func logout(for provider: Provider) {
        interactor.logout(for: provider)
    }

}
