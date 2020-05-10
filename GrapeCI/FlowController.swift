//
//  FlowController.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 06/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation
import Cocoa
import SwiftUI
import Combine

// sourcery: autoSpy
protocol FlowControllerProtocol: AnyObject {
    func handleOauthRedirectURL(_ url: URL)

    func loadMenu()
    func loadWelcomeIfNeeded()
    func loadConfigurationModule()
    func loadListModule()
    func loadIntegrationModule(repository: GitRepository)
    func loadStatusModule()
    func startScheduler()

    func didChangeIntegratedRepositories()
}

class FlowController: FlowControllerProtocol {
    private var gitProvider: GitProviderProtocol

    private var scheduler: SchedulerController?
    private var listViewController: ListViewController?
    private var integrationViewController: IntegrateViewController?
    private var statusViewController: StatusViewController?
    private var appIcon: AppIcon?
    private var builder: BuilderController

    private var cancelables = Set<AnyCancellable>()

    init() {
        let coreData = CoreDataStack()
        gitProvider = GitProvider(coreData: coreData)
        gitProvider.startMonitoringNetworkChanges()

        builder = BuilderController(gitProvider: gitProvider)
        builder
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                self?.changeAppIcon(action: action)
        }
        .store(in: &cancelables)
    }

    func startScheduler() {
        scheduler = SchedulerController(flowController: self, gitProvider: gitProvider)
        scheduler?.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else { return }
            self.scheduler?.start()
        }
    }

    func handleOauthRedirectURL(_ url: URL) {
        print("Handle oaut Redirect url \(url.absoluteString).")
        gitProvider.handleOauthRedirectURL(url)
    }

    func loadMenu() {
        var topLevelObjects: NSArray? = []
        Bundle.main.loadNibNamed("Menu", owner: self, topLevelObjects: &topLevelObjects)
        NSApplication.shared.mainMenu = topLevelObjects?.filter { $0 is NSMenu }.first as? NSMenu
    }

    func loadWelcomeIfNeeded() {
        if gitProvider.providers.count == 0 {
            loadConfigurationModule()
        }
    }

    /// Load Welcome module and set a view for oauth authentication
    func loadConfigurationModule() {
        let interactor = FetchUserInteractor(gitProvider: gitProvider)
        let presenter = WelcomePresenter(interactor: interactor)
        let welcomeView = WelcomeView(presenter: presenter, flowController: self)

        let loginWindow = ClosableWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 500),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false)

        gitProvider.authenticateView = loginWindow

        loginWindow.setFrameAutosaveName("Configuration Window")
        loginWindow.center()
        loginWindow.contentView = NSHostingView(rootView: welcomeView)
        loginWindow.makeKeyAndOrderFront(loginWindow)

        NSApp.activate(ignoringOtherApps: true)
    }

    func loadListModule() {
        let interactor = FetchGitRepositoriesInteractor(gitProvider: gitProvider)
        let presenter = ListPresenter(fetchGitRepositoriesInterator: interactor)
        listViewController = ListViewController(presenter: presenter, flowController: self)

        statusViewController?.presentAsModalWindow(listViewController!)
    }

    func loadIntegrationModule(repository: GitRepository) {
        let interactor = IntegrateInteractor(gitProvider: gitProvider)
        let presenter = IntegratePresenter(repository: repository, integrateInterator: interactor)
        integrationViewController = IntegrateViewController(presenter: presenter, flowController: self)

        listViewController?.presentAsSheet(integrationViewController!)
    }

    func loadStatusModule() {
        let interactor = RefreshGitRepositoryInterator(gitProvider: gitProvider)
        let presenter = StatusPresenter(refreshGitRepositoryInterator: interactor)
        statusViewController = StatusViewController(presenter: presenter, flowController: self)

        appIcon = AppIcon(contentViewController: statusViewController!)
    }

    func didChangeIntegratedRepositories() {
        integrationViewController?.dismiss(self)
        listViewController?.clear()
    }

    private func changeAppIcon(action: BuilderController.Action) {
        switch action {
        case .buildStart:
            appIcon?.show(for: .inprogress)
        case .buildFinish(status: let status):
            appIcon?.show(for: status)
        }
    }

}

extension FlowController: SchedulerDelegate {

    func didRefreshRepositories(repositories: [GitRepository]) {
        builder.buildIfNeeded(repositories: repositories)
    }

}
