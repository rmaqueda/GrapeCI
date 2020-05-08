//
//  ListPresenterTests.swift
//  GrapeCITests
//
//  Created by Ricardo Maqueda Martinez on 31/03/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import XCTest
import Combine
@testable import GrapeCI

class ListPresenterTests: XCTestCase {
    var sut: ListPresenter!
    var interactor: SpyFetchGitRepositoriesInteractorProtocol!
    private var subscriptions = Set<AnyCancellable>()

    override func setUpWithError() throws {
        try super.setUpWithError()

        interactor = SpyFetchGitRepositoriesInteractorProtocol()
        interactor.integratedRepositoriesResult = []

        sut = ListPresenter(fetchGitRepositoriesInterator: interactor)
    }

    override func tearDownWithError() throws {
        interactor = nil
        sut = nil

        try super.tearDownWithError()
    }

}
