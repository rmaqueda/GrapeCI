//
//  SchedulerController.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 20/02/2020.
//  Copyright © 2020 Ricardo.Maqueda. All rights reserved.
//

import Foundation
import Combine

protocol SchedulerDelegate: AnyObject {
    func didRefreshRepositories(repositories: [GitRepository])
}

class SchedulerController {
    weak var delegate: SchedulerDelegate?
    private let gitProvider: GitProviderProtocol
    private let flowController: FlowController
    private var subscriptions = Set<AnyCancellable>()

    init(flowController: FlowController, gitProvider: GitProviderProtocol) {
        self.gitProvider = gitProvider
        self.flowController = flowController
    }

    func start() {
        fireTimer(date: Date())

        Timer
            .publish(every: Constants.pullInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] in self?.fireTimer(date: $0) }
            .store(in: &subscriptions)
    }

    private func fireTimer(date: Date) {
        print("Runing scheduled task. \(date)")
        gitProvider.refreshIntegratedRepositories()
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .sink { [weak self] repositories in
                guard let self = self else { return }
                guard repositories.count > 0 else { return }
                self.delegate?.didRefreshRepositories(repositories: repositories)
            }
            .store(in: &subscriptions)
    }

}
