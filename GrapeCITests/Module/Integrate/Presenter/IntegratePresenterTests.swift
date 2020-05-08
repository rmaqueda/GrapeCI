//
//  IntegratePresenterTests.swift
//  GrapeCIUnitTests
//
//  Created by Ricardo Maqueda Martinez on 10/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import XCTest
@testable import GrapeCI

class IntegratePresenterTests: XCTestCase {
    var sut: IntegratePresenter!
    let interactor = SpyIntegrateInteractorProtocol()
    var repository: GitRepository!

    override func setUpWithError() throws {
        try super.setUpWithError()

        repository = GitRepository.mock
        sut = IntegratePresenter(repository: repository, integrateInterator: interactor)
    }

    override func tearDownWithError() throws {
        repository = nil
        sut = nil

        try super.tearDownWithError()
    }

    func test_Computed_Variables_PipeLine_Nil() {
        // GIVEN:   A repository injected
        // WHEN:
        // THEN:    The computed variables match

        XCTAssertEqual(sut.title, "Integration for: name")
        XCTAssertEqual(sut.pipeline, "")
        XCTAssertEqual(sut.buttonTitle, "Save")
        XCTAssertEqual(sut.deIntegrateButtonTitle, "Cancel")
    }


    func test_Computed_Variables_PipeLine_NON_Nil() {
        // GIVEN:   A repository injected with non nil pipeline
        // WHEN:
        // THEN:    The computed variables match
        repository.pipeline = "non nil"
        sut = IntegratePresenter(repository: repository, integrateInterator: interactor)

        XCTAssertEqual(sut.title, "Integration for: name")
        XCTAssertEqual(sut.pipeline, "non nil")
        XCTAssertEqual(sut.buttonTitle, "Save")
        XCTAssertEqual(sut.deIntegrateButtonTitle, "DeIntegrate")
    }

    func test_integrate_isCalled() {
        // GIVEN:
        // WHEN:    integrate is called
        // THEN:    The repository pipeline match and integrate in interactor is called

        repository.pipeline = "previous"

        sut.integrate(pipeline: "new")

        repository.pipeline = "new"

        XCTAssertTrue(interactor.check(method: .integrate(repository: repository),
                                       predicate: CallstackMatcher.times(1)))
    }


    func test_deIntegrate_isCalled() {
        // GIVEN:
        // WHEN:    integrate is called
        // THEN:    The repository pipeline match and integrate in interactor is called

        sut.deIntegrate()

        XCTAssertTrue(interactor.check(method: .deIntegrate(repository: repository),
                                       predicate: CallstackMatcher.times(1)))
    }


}
