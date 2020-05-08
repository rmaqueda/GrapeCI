//
//  BitBucketMock.swift
//  GrapeCITests
//
//  Created by Ricardo Maqueda Martinez on 04/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation
import Combine
@testable import GrapeCI

//class BitBucketMock: BitBucketProviderProtocol {
//    var user: BitBucketUser?
//
//    var repositoriesIsCalled = false
//    var authorizeIsCalled = false
//
//    var result: BitBucketPaginated<BitBucketRepository>?
//    var error: Error?
//
//    func authorize() {
//        authorizeIsCalled = true
//    }
//
//    func repositories(nameFilter: String) -> AnyPublisher<BitBucketPaginated<BitBucketRepository>, Error> {
//        repositoriesIsCalled = true
//
//        return Future<BitBucketPaginated<BitBucketRepository>, Error> { promise in
//            if let result = self.result {
//                promise(.success(result))
//            } else if let error = self.error {
//                promise(.failure(error))
//            }
//        }.eraseToAnyPublisher()
//    }
//
//    func repository(identifier: String, workspaceID: String) -> AnyPublisher<BitBucketRepository, Error> {
//        return Future<BitBucketRepository, Error> { promise in
//        //TODO: Implement
//        }.eraseToAnyPublisher()
//    }
//
//}
