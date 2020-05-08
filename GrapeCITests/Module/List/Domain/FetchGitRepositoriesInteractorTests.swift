//
//  FetchGitRepositoriesInteractorTests.swift
//  GrapeCITests
//
//  Created by Ricardo Maqueda Martinez on 04/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import XCTest
import Combine
@testable import GrapeCI

class FetchGitRepositoriesInteractorTests: XCTestCase {
    var sut: FetchGitRepositoriesInteractor!
    var gitProvider = SpyGitProviderProtocol()

    override func setUpWithError() throws {
        try super.setUpWithError()

        sut = FetchGitRepositoriesInteractor(gitProvider: gitProvider)
    }

    override func tearDownWithError() throws {
        sut = nil

        try super.tearDownWithError()
    }

    func test_IntegratedRepositories() {
        // GIVEN:   A GitRepositoryMock
        // WHEN:    call to integratedRepositories
        // THEN:    integratedRepositories is called and response match

        gitProvider.integratedRepositoriesResult = [GitRepository.mock]
        let integratedRepositories = sut.integratedRepositories()

        XCTAssertTrue(gitProvider.check(method: .integratedRepositories,
                                        predicate: CallstackMatcher.times(1)))
        XCTAssertEqual(integratedRepositories.count, 1)
    }

    func test_fetchRepositories_with_success() {
        // GIVEN: GitRepositoryMock with a success response
        // WHEN:  call to fetchRepositories with a filter
        // THEN:  check fetchRepositories is called with same filter and the response match

        let exp = expectation(description: "")
        let repo = GitRepository.mock
        gitProvider.fetchRepositoriesResult = CurrentValueSubject([repo]).eraseToAnyPublisher()

        let _ = sut.fetchRepositories(nameFilter: "filter")
            .sink(receiveCompletion: { _ in },
                  receiveValue: { repositories in
                    exp.fulfill()
                    XCTAssertEqual(repositories.count, 1)
                    XCTAssertEqual(repositories.first, repo)
            })

        wait(for: [exp], timeout: 1)
        XCTAssertTrue(gitProvider.check(method: .fetchRepositories(nameFilter: "filter"),
                                        predicate: CallstackMatcher.times(1)))
    }

    func test_fetchRepositories_with_error() {
        // GIVEN: GitRepositoryMock with a success response
        // WHEN:  call to fetchRepositories with a filter
        // THEN:  check fetchRepositories is called with same filter and the response match
        
        let exp = expectation(description: "")

        let futureError = NetworkError.login
        let future = Future<[GitRepository], Error> { promise in
            promise(.failure(futureError))
        }.eraseToAnyPublisher()

        gitProvider.fetchRepositoriesResult = future

        _ = sut.fetchRepositories(nameFilter: "filter")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Should not finish")
                case .failure(let error):
                    XCTAssertEqual(error as? NetworkError, futureError)
                    exp.fulfill()
                }
            }, receiveValue: { _ in })

        wait(for: [exp], timeout: 1)
        XCTAssertTrue(gitProvider.check(method: .fetchRepositories(nameFilter: "filter"),
                                        predicate: CallstackMatcher.times(1)))
    }

}
