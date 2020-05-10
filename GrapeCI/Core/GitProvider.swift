//
//  GitProvider.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 22/03/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//
import Foundation
import Combine
import CoreData
import Network
import AppKit

class GitProvider: GitProviderProtocol {
    var authenticateView: NSWindow?
    private(set) var providers: [GitProviderAdapter] = []
    private let coreData: CoreDataProtocol
    private let networkMonitor = NWPathMonitor()
    private var cancelables = Set<AnyCancellable>()

    init(coreData: CoreDataProtocol) {
        self.coreData = coreData

        addLoggedProviders()
    }

    private func addLoggedProviders() {
        let query: NSFetchRequest<LoggedProvider> = LoggedProvider.fetchRequest()
        let result = try? coreData.viewContext.fetch(query)

        result?.forEach { provider in
            if provider.name == Provider.bitBucket.rawValue {
                if !providers.contains(where: { $0.providerName.rawValue == "BitBucket" }) {
                    let bitBucket = BitBucket()
                    bitBucket.update()
                    providers.append(bitBucket)
                }
            }
            if provider.name == Provider.gitHub.rawValue {
                if !providers.contains(where: { $0.providerName.rawValue == "GitHub" }) {
                    let gitHub = GitHub()
                    gitHub.update()
                    providers.append(gitHub)
                }
            }
        }

    }

    private func removeProvider(provider: Provider) {
        providers = providers.filter { $0.providerName != provider }
    }

    private func saveLoggedProvider(provider: Provider) {
        let query: NSFetchRequest<LoggedProvider> = LoggedProvider.fetchRequest()
        query.predicate = NSPredicate(format: "name==%@", provider.rawValue)

        if let result = try? coreData.viewContext.fetch(query), result.count > 0 {
            return
        } else {
            if let newProvider = NSEntityDescription.insertNewObject(forEntityName: "LoggedProvider",
                                                                  into: coreData.viewContext) as? LoggedProvider {
                newProvider.name = provider.rawValue
            }
        }

        do {
            try coreData.viewContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func deleteLoggedProvider(provider: Provider) {
        let query: NSFetchRequest<LoggedProvider> = LoggedProvider.fetchRequest()
        query.predicate = NSPredicate(format: "name==%@", provider.rawValue)

        if let loggedProviders = try? coreData.viewContext.fetch(query).first {
            coreData.viewContext.delete(loggedProviders)
        }

        do {
            try coreData.viewContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func gitProviderOrNil(for provider: Provider) -> GitProviderAdapter? {
        providers.filter { $0.providerName == provider }.first
    }

    private func gitProvider(for provider: Provider) -> AnyPublisher<GitProviderAdapter, Error> {
        Future<GitProviderAdapter, Error> { promise in
            if  let provider = self.providers.filter({ $0.providerName == provider }).first {
                promise(.success(provider))
            } else {
                promise(.failure(NetworkError.login))
            }
        }.eraseToAnyPublisher()
    }

    func startMonitoringNetworkChanges() {
        print("Observing network status changes.")
        networkMonitor.start(queue: DispatchQueue(label: "es.moletudio.network.monitor"))
        networkMonitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                print("Updating providers.")
                self?.providers.forEach { $0.update() }
            }
        }
    }

    func handleOauthRedirectURL(_ url: URL) {
        print("Handle aout rediret url \(url.absoluteString).")
        if url.absoluteString.contains("github") {
            gitProviderOrNil(for: .gitHub)?.handleRedirectURL(url)
        } else if url.absoluteString.contains("bitbucket") {
            gitProviderOrNil(for: .bitBucket)?.handleRedirectURL(url)
        }
    }

    func isAuthenticated(for provider: Provider) -> Bool {
        gitProviderOrNil(for: provider)?.user != nil
    }

    func authenticate(for provider: Provider) -> AnyPublisher<GitUser, Error> {
        guard let window = self.authenticateView else {
            fatalError("Authetication require a window.")
        }

        let aProvider: GitProviderAdapter
        switch provider {
        case .gitHub:
            aProvider = GitHub()
        case .bitBucket:
            aProvider = BitBucket()
        }

        return Future<GitUser, Error> { promise in
            aProvider.authorize(in: window)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }, receiveValue: { user in
                    self.saveLoggedProvider(provider: provider)
                    self.addLoggedProviders()
                    promise(.success(user))
                })
                .store(in: &self.cancelables)
        }
        .eraseToAnyPublisher()
    }

    func logout(for provider: Provider) {
        gitProviderOrNil(for: provider)?.logout()
        removeProvider(provider: provider)
        deleteLoggedProvider(provider: provider)
    }

    func integratedRepositories() -> [GitRepository] {
        let query: NSFetchRequest<IntegratedRepository> = IntegratedRepository.fetchRequest()
        guard let result = try? coreData.viewContext.fetch(query) else {
            return []
        }
        return result.map {
            GitRepository(identifier: $0.identifier,
                          name: $0.name,
                          fullName: $0.fullName,
                          provider: Provider(rawValue: $0.providerName)!,
                          defaultBranch: GitBranch(name: $0.defaultBranch),
                          url: "",
                          workspaceID: $0.workspaceID,
                          pipeline: $0.pipeline)
        }
    }

    func integrate(repository: GitRepository,
                   progress: @escaping (String) -> Void,
                   completion: @escaping (ShellResult) -> Void) {
        precondition(repository.pipeline != nil, "The pipeline must not be empty")

        if !FileManager.default.fileExists(atPath: repository.directory) {
            let authString = aouthString(for: repository)
            repository.clone(
                authString: authString,
                progress: progress,
                completion: { result in
                    if result.status == 0 {
                        self.insertIntegrateRepository(repository: repository)
                    } else {
                        try? repository.deleteRepositoryDir()
                        fatalError("Error cloning repository")
                    }
                    completion(result)
            })
        } else {
            insertIntegrateRepository(repository: repository)
        }
    }

    private func insertIntegrateRepository(repository: GitRepository) {
        let query: NSFetchRequest<IntegratedRepository> = IntegratedRepository.fetchRequest()
        query.predicate = NSPredicate(format: "identifier==%@", repository.identifier)

        if let repo = try? coreData.viewContext.fetch(query).first {
            repo.pipeline = repository.pipeline!
        } else {
            if let repo = NSEntityDescription.insertNewObject(forEntityName: "IntegratedRepository",
                                                              into: coreData.viewContext) as? IntegratedRepository {
                repo.setProperties(repository: repository)
            }
        }

        do {
            try coreData.viewContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func aouthString(for repository: GitRepository) -> String {
        guard let token = gitProviderOrNil(for: repository.provider)?.token else {
            fatalError("Unable to get ouath token for clone repository")
        }

        switch repository.provider {
        case .gitHub: return token
        case .bitBucket: return "x-token-auth:{\(token)}"
        }
    }

    func deIntegrate(repository: GitRepository) {
        let query: NSFetchRequest<IntegratedRepository> = IntegratedRepository.fetchRequest()
        query.predicate = NSPredicate(format: "identifier==%@", repository.identifier)

        if let integratedRepo = try? coreData.viewContext.fetch(query).first {
            coreData.viewContext.delete(integratedRepo)
        }

        do {
            try coreData.viewContext.save()
            if FileManager.default.fileExists(atPath: repository.directory) {
                try FileManager.default.removeItem(atPath: repository.directory)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func fetchRepositories(nameFilter: String) -> AnyPublisher<[GitRepository], Error> {
        providers.map { $0.repositories(nameFilter: nameFilter) }
            .zip
            .map { $0.reduce([], +) }
            .eraseToAnyPublisher()
    }

    func refreshIntegratedRepositories() -> AnyPublisher<[GitRepository], Error> {
        let integratedRepos = integratedRepositories()

        let publishers = Publishers.Sequence<[AnyPublisher<GitRepository, Error>], Error>(sequence:
            integratedRepos.map(refresh(repository:))
        )

        return publishers
            .flatMap { $0 }
            .collect()
            .eraseToAnyPublisher()
    }

    private func refresh(repository: GitRepository) -> AnyPublisher<GitRepository, Error> {
        gitProvider(for: repository.provider)
            .flatMap({ $0.repository(identifier: repository.identifier, workspaceID: repository.workspaceID) })
            .flatMap(refreshLastCommit(for:))
            .flatMap(refreshBuildsLastComit(for:))
            .flatMap(refreshPullRequests(for:))
            .flatMap(refreshBuildsPullRequests(for:))
            .map(addPipeLine(for:))
            .eraseToAnyPublisher()
    }

    private func refreshLastCommit(for repository: GitRepository) -> AnyPublisher<GitRepository, Error> {
        gitProvider(for: repository.provider)
            .flatMap({ $0.lastCommit(repository: repository, branchName: repository.defaultBranch.name) })
            .map({ commit in
                repository.defaultBranch.lastCommit = commit
                return repository
            })
            .eraseToAnyPublisher()
    }

    private func refreshBuildsLastComit(for repository: GitRepository) -> AnyPublisher<GitRepository, Error> {
        gitProvider(for: repository.provider)
            .flatMap({ $0.builds(repository: repository, commit: repository.defaultBranch.lastCommit!.sha) })
            .map({ builds in
                let buildsWithLog = builds.map { self.addLog(for: repository, to: $0) }
                repository.defaultBranch.lastCommit?.builds = buildsWithLog
                return repository
            })
            .eraseToAnyPublisher()
    }

    private func refreshPullRequests(for repository: GitRepository) -> AnyPublisher<GitRepository, Error> {
        gitProvider(for: repository.provider)
            .flatMap({ $0.pullRequests(repository: repository) })
            .map({ pullrequests in
                repository.pullRequests = pullrequests
                return repository
            })
            .eraseToAnyPublisher()
    }

    private func refreshBuildsPullRequests(for repository: GitRepository) -> AnyPublisher<GitRepository, Error> {
        let publishers = Publishers.Sequence<[AnyPublisher<GitRepository, Error>], Error>(sequence:
            repository.pullRequests.map { pullRequest in
                gitProvider(for: repository.provider)
                    .flatMap({ $0.builds(repository: repository, commit: pullRequest.destination.lastCommit!.sha) })
                    .map({ builds in
                        let buildsWithLog = builds.map { self.addLog(for: repository, to: $0) }
                        pullRequest.destination.lastCommit?.builds = buildsWithLog
                        return repository
                    })
                    .eraseToAnyPublisher()
        })

        return publishers
            .flatMap { $0 }
            .collect()
            .map { _ in repository }
            .eraseToAnyPublisher()
    }

    func createBuild(repository: GitRepository,
                     commit: GitCommit,
                     state: GitBuildState) -> AnyPublisher<GitBuild, Error> {
        gitProvider(for: repository.provider)
            .flatMap({ $0.createBuild(repository: repository, commit: commit, state: state) })
            .eraseToAnyPublisher()
    }

    func saveBuildLog(buildId: String, providerName: String, log: String) {
        let buildIdPredicate = NSPredicate(format: "identifier == '\(buildId)'")
        let providerPredicate = NSPredicate(format: "providerName == '\(providerName)'")
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [buildIdPredicate, providerPredicate])

        let query: NSFetchRequest<BuildLog> = BuildLog.fetchRequest()
        query.predicate = andPredicate

        if let build = try? coreData.viewContext.fetch(query).first {
            build.log = log
        } else {
            if let buildlog = NSEntityDescription.insertNewObject(forEntityName: "BuildLog",
                                                                  into: coreData.viewContext) as? BuildLog {
                buildlog.providerName = providerName
                buildlog.log = log
                buildlog.identifier = buildId
            }
        }
        do {
            try coreData.viewContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func addPipeLine(for repository: GitRepository) -> GitRepository {
        let integrated = integratedRepositories()
        let integratedRepo = integrated.filter({ $0.identifier == repository.identifier }).first

        repository.pipeline = integratedRepo?.pipeline
        return repository
    }

    private func addLog(for repository: GitRepository, to build: GitBuild) -> GitBuild {
        let buildIdPredicate = NSPredicate(format: "identifier == '\(build.key)'")
        let providerPredicate = NSPredicate(format: "providerName == '\(repository.provider.rawValue)'")
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [buildIdPredicate, providerPredicate])

        let query: NSFetchRequest<BuildLog> = BuildLog.fetchRequest()
        query.predicate = andPredicate

        guard let results = try? coreData.viewContext.fetch(query),
            let log = results.first?.log else {
                return build
        }

        var build = build
        build.log = log

        return build
    }

}
