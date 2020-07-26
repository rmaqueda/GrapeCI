// Generated using Sourcery 0.18.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


import Foundation
import Cocoa
import Combine
@testable import GrapeCI

// swiftlint:disable force_cast

// MARK: Spy for CoreDataProtocol
public class SpyCoreDataProtocol: CoreDataProtocol, TestSpy {
	public enum Method: Equatable {
	}
    public var viewContext: NSManagedObjectContext {
        get { return underlyingViewContext }
        set(value) { underlyingViewContext = value }
    }
    public var underlyingViewContext: NSManagedObjectContext!
    public var backgroundContext: NSManagedObjectContext {
        get { return underlyingBackgroundContext }
        set(value) { underlyingBackgroundContext = value }
    }
    public var underlyingBackgroundContext: NSManagedObjectContext!
	public var callstack = CallstackContainer<Method>()
    public init() {}
}

// MARK: Spy for FetchGitRepositoriesInteractorProtocol
public class SpyFetchGitRepositoriesInteractorProtocol: FetchGitRepositoriesInteractorProtocol, TestSpy {
	public enum Method: Equatable {
        case integratedRepositories
        case fetchRepositories(nameFilter: String)
	}
	public var callstack = CallstackContainer<Method>()
    public init() {}
    public var integratedRepositoriesResult: [GitRepository]!
    public func integratedRepositories() -> [GitRepository] {
        callstack.record(.integratedRepositories)
        return integratedRepositoriesResult
    }
    public var fetchRepositoriesResult: AnyPublisher<[GitRepository], Error>!
    public func fetchRepositories(nameFilter: String) -> AnyPublisher<[GitRepository], Error> {
        callstack.record(.fetchRepositories(nameFilter: nameFilter ))
        return fetchRepositoriesResult
    }
}

// MARK: Spy for FlowControllerProtocol
public class SpyFlowControllerProtocol: FlowControllerProtocol, TestSpy {
	public enum Method: Equatable {
        case handleOauthRedirectURL(url: URL)
        case loadMenu
        case loadWelcomeIfNeeded
        case loadConfigurationModule
        case loadListModule
        case loadIntegrationModule(repository: GitRepository)
        case loadStatusModule
        case startScheduler
        case didChangeIntegratedRepositories
	}
	public var callstack = CallstackContainer<Method>()
    public init() {}
    public func handleOauthRedirectURL(_ url: URL) {
        callstack.record(.handleOauthRedirectURL(url: url ))
    }
    public func loadMenu() {
        callstack.record(.loadMenu)
    }
    public func loadWelcomeIfNeeded() {
        callstack.record(.loadWelcomeIfNeeded)
    }
    public func loadConfigurationModule() {
        callstack.record(.loadConfigurationModule)
    }
    public func loadListModule() {
        callstack.record(.loadListModule)
    }
    public func loadIntegrationModule(repository: GitRepository) {
        callstack.record(.loadIntegrationModule(repository: repository ))
    }
    public func loadStatusModule() {
        callstack.record(.loadStatusModule)
    }
    public func startScheduler() {
        callstack.record(.startScheduler)
    }
    public func didChangeIntegratedRepositories() {
        callstack.record(.didChangeIntegratedRepositories)
    }
}

// MARK: Spy for GitProviderAdapter
public class SpyGitProviderAdapter: GitProviderAdapter, TestSpy {
	public enum Method: Equatable {
        case update
        case authorize(window: NSWindow)
        case handleRedirectURL(url: URL)
        case logout
        case repositories(nameFilter: String)
        case repository(identifier: String, workspaceID: String?)
        case pullRequests(repository: GitRepository)
        case lastCommit(repository: GitRepository, branchName: String)
        case builds(repository: GitRepository, commit: String)
        case createBuild(repository: GitRepository, commit: GitCommit, state: GitBuildState)
	}
    public var providerName: Provider {
        get { return underlyingProviderName }
        set(value) { underlyingProviderName = value }
    }
    public var underlyingProviderName: Provider!
    public var user: GitUser?
    public var token: String?
	public var callstack = CallstackContainer<Method>()
    public init() {}
    public func update() {
        callstack.record(.update)
    }
    public var authorizeResult: AnyPublisher<GitUser, Error>!
    public func authorize(in window: NSWindow) -> AnyPublisher<GitUser, Error> {
        callstack.record(.authorize(window: window ))
        return authorizeResult
    }
    public func handleRedirectURL(_ url: URL) {
        callstack.record(.handleRedirectURL(url: url ))
    }
    public func logout() {
        callstack.record(.logout)
    }
    public var repositoriesResult: AnyPublisher<[GitRepository], Error>!
    public func repositories(nameFilter: String) -> AnyPublisher<[GitRepository], Error> {
        callstack.record(.repositories(nameFilter: nameFilter ))
        return repositoriesResult
    }
    public var repositoryResult: AnyPublisher<GitRepository, Error>!
    public func repository(identifier: String, workspaceID: String?) -> AnyPublisher<GitRepository, Error> {
        callstack.record(.repository(identifier: identifier , workspaceID: workspaceID ))
        return repositoryResult
    }
    public var pullRequestsResult: AnyPublisher<[GitPullRequest], Error>!
    public func pullRequests(repository: GitRepository) -> AnyPublisher<[GitPullRequest], Error> {
        callstack.record(.pullRequests(repository: repository ))
        return pullRequestsResult
    }
    public var lastCommitResult: AnyPublisher<GitCommit, Error>!
    public func lastCommit(repository: GitRepository, branchName: String) -> AnyPublisher<GitCommit, Error> {
        callstack.record(.lastCommit(repository: repository , branchName: branchName ))
        return lastCommitResult
    }
    public var buildsResult: AnyPublisher<[GitBuild], Error>!
    public func builds(repository: GitRepository, commit: String) -> AnyPublisher<[GitBuild], Error> {
        callstack.record(.builds(repository: repository , commit: commit ))
        return buildsResult
    }
    public var createBuildResult: AnyPublisher<GitBuild, Error>!
    public func createBuild(repository: GitRepository,                     commit: GitCommit,                     state: GitBuildState) -> AnyPublisher<GitBuild, Error> {
        callstack.record(.createBuild(repository: repository , commit: commit , state: state ))
        return createBuildResult
    }
}

// MARK: Spy for GitProviderProtocol
public class SpyGitProviderProtocol: GitProviderProtocol, TestSpy {
	public enum Method: Equatable {
        case startMonitoringNetworkChanges
        case isAuthenticated(provider: Provider)
        case authenticate(provider: Provider)
        case logout(provider: Provider)
        case handleOauthRedirectURL(url: URL)
        case integratedRepositories
        case integrate(repository: GitRepository)
        case deIntegrate(repository: GitRepository)
        case aouthString(repository: GitRepository)
        case refreshIntegratedRepositories
        case fetchRepositories(nameFilter: String)
        case createBuild(repository: GitRepository, commit: GitCommit, state: GitBuildState)
        case saveBuildLog(buildId: String, providerName: String, log: String)
	}
    public var authenticateView: NSWindow?
    public var providers: [GitProviderAdapter] = []
	public var callstack = CallstackContainer<Method>()
    public init() {}
    public func startMonitoringNetworkChanges() {
        callstack.record(.startMonitoringNetworkChanges)
    }
    public var isAuthenticatedResult: Bool!
    public func isAuthenticated(for provider: Provider) -> Bool {
        callstack.record(.isAuthenticated(provider: provider ))
        return isAuthenticatedResult
    }
    public var authenticateResult: AnyPublisher<GitUser, Error>!
    public func authenticate(for provider: Provider) -> AnyPublisher<GitUser, Error> {
        callstack.record(.authenticate(provider: provider ))
        return authenticateResult
    }
    public func logout(for provider: Provider) {
        callstack.record(.logout(provider: provider ))
    }
    public func handleOauthRedirectURL(_ url: URL) {
        callstack.record(.handleOauthRedirectURL(url: url ))
    }
    public var integratedRepositoriesResult: [GitRepository]!
    public func integratedRepositories() -> [GitRepository] {
        callstack.record(.integratedRepositories)
        return integratedRepositoriesResult
    }
    public func integrate(repository: GitRepository,                   progress: @escaping (String) -> Void,                   completion: @escaping (ShellResult) -> Void) {
        callstack.record(.integrate(repository: repository ))
    }
    public func deIntegrate(repository: GitRepository) {
        callstack.record(.deIntegrate(repository: repository ))
    }
    public var aouthStringResult: String!
    public func aouthString(for repository: GitRepository) -> String {
        callstack.record(.aouthString(repository: repository ))
        return aouthStringResult
    }
    public var refreshIntegratedRepositoriesResult: AnyPublisher<[GitRepository], Error>!
    public func refreshIntegratedRepositories() -> AnyPublisher<[GitRepository], Error> {
        callstack.record(.refreshIntegratedRepositories)
        return refreshIntegratedRepositoriesResult
    }
    public var fetchRepositoriesResult: AnyPublisher<[GitRepository], Error>!
    public func fetchRepositories(nameFilter: String) -> AnyPublisher<[GitRepository], Error> {
        callstack.record(.fetchRepositories(nameFilter: nameFilter ))
        return fetchRepositoriesResult
    }
    public var createBuildResult: AnyPublisher<GitBuild, Error>!
    public func createBuild(repository: GitRepository,                     commit: GitCommit,                     state: GitBuildState) -> AnyPublisher<GitBuild, Error> {
        callstack.record(.createBuild(repository: repository , commit: commit , state: state ))
        return createBuildResult
    }
    public func saveBuildLog(buildId: String, providerName: String, log: String) {
        callstack.record(.saveBuildLog(buildId: buildId , providerName: providerName , log: log ))
    }
}

// MARK: Spy for IntegrateInteractorProtocol
public class SpyIntegrateInteractorProtocol: IntegrateInteractorProtocol, TestSpy {
	public enum Method: Equatable {
        case integrate(repository: GitRepository)
        case deIntegrate(repository: GitRepository)
	}
	public var callstack = CallstackContainer<Method>()
    public init() {}
    public func integrate(repository: GitRepository,                   progress: @escaping (String) -> Void,                   completion: @escaping (ShellResult) -> Void) {
        callstack.record(.integrate(repository: repository ))
    }
    public func deIntegrate(repository: GitRepository) {
        callstack.record(.deIntegrate(repository: repository ))
    }
}

// MARK: Spy for IntegratePresenterProtocol
public class SpyIntegratePresenterProtocol: IntegratePresenterProtocol, TestSpy {
	public enum Method: Equatable {
        case integrate(pipeline: String)
        case deIntegrate
	}
    public var title: String {
        get { return underlyingTitle }
        set(value) { underlyingTitle = value }
    }
    public var underlyingTitle: String!
    public var pipeline: String {
        get { return underlyingPipeline }
        set(value) { underlyingPipeline = value }
    }
    public var underlyingPipeline: String!
    public var buttonTitle: String {
        get { return underlyingButtonTitle }
        set(value) { underlyingButtonTitle = value }
    }
    public var underlyingButtonTitle: String!
    public var deIntegrateButtonTitle: String {
        get { return underlyingDeIntegrateButtonTitle }
        set(value) { underlyingDeIntegrateButtonTitle = value }
    }
    public var underlyingDeIntegrateButtonTitle: String!
	public var callstack = CallstackContainer<Method>()
    public init() {}
    public func integrate(pipeline: String,                   progress: @escaping (String) -> Void,                   completion: @escaping (ShellResult) -> Void) {
        callstack.record(.integrate(pipeline: pipeline ))
    }
    public func deIntegrate() {
        callstack.record(.deIntegrate)
    }
}

// MARK: Spy for ListPresenterProtocol
public class SpyListPresenterProtocol: ListPresenterProtocol, TestSpy {
	public enum Method: Equatable {
        case fetchRepositories(nameFilter: String)
	}
	public var callstack = CallstackContainer<Method>()
    public init() {}
    public var fetchRepositoriesResult: AnyPublisher<[GitRepository], Error>!
    public func fetchRepositories(nameFilter: String) -> AnyPublisher<[GitRepository], Error> {
        callstack.record(.fetchRepositories(nameFilter: nameFilter ))
        return fetchRepositoriesResult
    }
}

// MARK: Spy for RefreshGitRepositoryInteratorProtocol
public class SpyRefreshGitRepositoryInteratorProtocol: RefreshGitRepositoryInteratorProtocol, TestSpy {
	public enum Method: Equatable {
        case refreshIntegratedRepositories
	}
	public var callstack = CallstackContainer<Method>()
    public init() {}
    public var refreshIntegratedRepositoriesResult: AnyPublisher<[GitRepository], Error>!
    public func refreshIntegratedRepositories() -> AnyPublisher<[GitRepository], Error> {
        callstack.record(.refreshIntegratedRepositories)
        return refreshIntegratedRepositoriesResult
    }
}

// MARK: Spy for StatusPresenterProtocol
public class SpyStatusPresenterProtocol: StatusPresenterProtocol, TestSpy {
	public enum Method: Equatable {
        case refreshIntegratedRepositories
	}
	public var callstack = CallstackContainer<Method>()
    public init() {}
    public var refreshIntegratedRepositoriesResult: AnyPublisher<[StatusViewModel], Error>!
    public func refreshIntegratedRepositories() -> AnyPublisher<[StatusViewModel], Error> {
        callstack.record(.refreshIntegratedRepositories)
        return refreshIntegratedRepositoriesResult
    }
}

// swiftlint:enable force_cast
