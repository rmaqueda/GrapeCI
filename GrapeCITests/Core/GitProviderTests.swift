//
//  GitProviderTests.swift
//  GrapeCITests
//
//  Created by Ricardo Maqueda Martinez on 04/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import XCTest
import Combine
@testable import GrapeCI

class GitProviderTests: XCTestCase {
//    var sut: GitProvider!
//    let coreData = CoreDataMock()
//    let bitBucket = BitBucketMock()
//    let gitHub = GitHubMock()
//    var subscriptions = Set<AnyCancellable>()
//
//    override func setUpWithError() throws {
//        try super.setUpWithError()
//
//        sut = GitProvider(gitHub: gitHub,
//                                      bitBucket: bitBucket,
//                                      coreData: coreData)
//
//    }
//
//    override func tearDownWithError() throws {
//        sut = nil
//
//        try super.tearDownWithError()
//    }
//
////    func testRepositoriesGitHubReturnErrorBitBucketError() {
////        // GIVEN: Mocked errors in providers
////        // WHEN:  Repositories is called
////        // THEN:  Error is returned
////
////        gitHub.error = NetworkError.empty
////        bitBucket.error = NetworkError.empty
////
////        let exp = expectation(description: "")
////        _ = sut.fetchRepositories(nameFilter: "stub")
////            .sink(receiveCompletion: { completion in
////                switch completion {
////                case .failure(let error):
////                    guard let error = error as? NetworkError else {
////                        XCTFail("Should be a NetworkError")
////                        return
////                    }
////                    XCTAssertEqual(error, NetworkError.empty)
////                default:
////                    XCTFail("Should fail")
////                }
////                exp.fulfill()
////            }, receiveValue: { repositories in
////                XCTFail("Should not called")
////            })
////
////        wait(for: [exp], timeout: 1)
////    }
//
//    func testRepositoriesBitBucketReturnError() {
//        // GIVEN: Mocked errors in BitBucket providers
//        // WHEN:  Repositories is called
//        // THEN:  Error is returned
//
//        bitBucket.error = NetworkError.generic(message: "stub")
//
//        let exp = expectation(description: "")
//        let cancelable = sut.fetchRepositories(nameFilter: "stub")
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .failure(let error):
//                    guard let error = error as? NetworkError else {
//                        XCTFail("Should be a NetworkError")
//                        return
//                    }
//                    XCTAssertEqual(error, NetworkError.generic(message: "stub"))
//                default:
//                    XCTFail("Should fail")
//                }
//                exp.fulfill()
//            }, receiveValue: { repositories in
//                XCTFail("Should not called")
//            })
//
//        wait(for: [exp], timeout: 1)
//        cancelable.cancel()
//    }
//
//    func testRepositoriesReturnEmptyValue() {
//        // GIVEN: Mocked values in BitBucket providers
//        // WHEN:  Repositories is called
//        // THEN:  Error is returned
//        bitBucket.result = BitBucketPaginated(pagelen: 1, items: [], page: 1, size: 1)
//        gitHub.result = GitHubPaginated(total: 1, isIncomplete: true, items: [])
//
//        let exp = expectation(description: "")
//        let cancelable = sut.fetchRepositories(nameFilter: "stub")
//            .sink(receiveCompletion: { _ in },
//                  receiveValue: { repositories in
//                    XCTAssertNotNil(repositories)
//                    exp.fulfill()
//            })
//
//        wait(for: [exp], timeout: 1)
//        cancelable.cancel()
//    }
//
//    func testRepositoriesReturnValues() {
//        // GIVEN: Mocked values in BitBucket providers
//        // WHEN:  Repositories is called
//        // THEN:  Repositories is returned
//
//        guard let repositoriesMock: BitBucketPaginated<BitBucketRepository> = JSONUtil().read(filename: "BitBucketPaginatedRepositories")
//            else {
//            XCTFail("Invalid json file")
//            return
//        }
//
//        bitBucket.result = repositoriesMock
//        gitHub.result = GitHubPaginated(total: 1, isIncomplete: true, items: [])
//
//        let exp = expectation(description: "")
//        let cancelable = sut.fetchRepositories(nameFilter: "stub")
//            .sink(receiveCompletion: { _ in },
//                  receiveValue: { repositories in
//                    XCTAssertEqual(repositories.count, 12)
//                    exp.fulfill()
//            })
//
//        wait(for: [exp], timeout: 1)
//        cancelable.cancel()
//    }
//
////    func testRepositoriesBitBucketReturnErrorGitHubReturnResult() {
////        // GIVEN: Mocked errors in BitBucket providers
////        // WHEN:  Repositories is called
////        // THEN:  Error is returned
////
////        bitBucket.error = NetworkError.generic(message: "stub")
////        gitHub.result = GitHubPaginated(total: 1, isIncomplete: true, items: [])
////
////        let exp = expectation(description: "")
////        _ = sut.fetchRepositories(nameFilter: "stub")
////            .sink(receiveCompletion: { completion in
////                switch completion {
////                case .failure(let error):
////                    guard let error = error as? NetworkError else {
////                        XCTFail("Should be a NetworkError")
////                        return
////                    }
////                    XCTAssertEqual(error, NetworkError.generic(message: "stub"))
////                default:
////                    XCTFail("Should fail")
////                }
////                exp.fulfill()
////            }, receiveValue: { repositories in
////                XCTFail("Should not called")
////            })
////
////        wait(for: [exp], timeout: 1)
////    }
//
//    func testRepositoriesGitHubReturnErrorBitBucketResult() {
//        // GIVEN: Mocked errors in BitBucket providers
//        // WHEN:  Repositories is called
//        // THEN:  Error is returned
//
//        bitBucket.result = BitBucketPaginated(pagelen: 0, items: [], page: 0, size: 0)
//        gitHub.error = NetworkError.generic(message: "stub")
//
//        let exp = expectation(description: "")
//        let cancelable = sut.fetchRepositories(nameFilter: "stub")
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .failure(let error):
//                    guard let error = error as? NetworkError else {
//                        XCTFail("Should be a NetworkError")
//                        return
//                    }
//                    XCTAssertEqual(error, NetworkError.generic(message: "stub"))
//                default:
//                    XCTFail("Should fail")
//                }
//                exp.fulfill()
//            }, receiveValue: { repositories in
//                XCTFail("Should not called")
//            })
//
//        wait(for: [exp], timeout: 1)
//        cancelable.cancel()
//    }

}
