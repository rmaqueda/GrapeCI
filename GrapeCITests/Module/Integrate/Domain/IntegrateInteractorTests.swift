//
//  IntegrateInteractorTests.swift
//  GrapeCIUnitTests
//
//  Created by Ricardo Maqueda Martinez on 10/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import XCTest
@testable import GrapeCI

class IntegrateInteractorTests: XCTestCase {
    var sut: IntegrateInteractor!
    let gitProvider = SpyGitProviderProtocol()
    let repository = GitRepository.mock

    override func setUpWithError() throws {
        try super.setUpWithError()

        sut = IntegrateInteractor(gitProvider: gitProvider)
    }

    override func tearDownWithError() throws {

        try super.tearDownWithError()
    }

    func test_integrate_isCalled() {
        // GIVEN:
        // WHEN:    integrate is called
        // THEN:    integrate is called on repository

        sut.integrate(repository: repository)
        XCTAssertTrue(gitProvider.check(method: .integrate(repository: repository),
                                        predicate: CallstackMatcher.times(1)))
    }

    func test_deIntegrate_isCalled() {
        // GIVEN:
        // WHEN:    deIntegrate is called
        // THEN:    deIntegrate is called on repository

        sut.deIntegrate(repository: repository)
        XCTAssertTrue(gitProvider.check(method: .deIntegrate(repository: repository),
                                        predicate: CallstackMatcher.times(1)))
    }

}
