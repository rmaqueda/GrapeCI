//
//  OAuth2DataLoader.swift
//  GrapeCI
//
//  Created by Ricardo.Maqueda on 01/05/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation
import OAuth2
import Combine

extension OAuth2DataLoader {

    func perform(request: URLRequest) -> AnyPublisher<(Data, URLResponse), Error> {
        Future<(Data, URLResponse), Error> { promise in
            self.perform(request: request) { response in
                if let error = response.error {
                    promise(.failure(error))
                } else if let data = response.data {
                    promise(.success((data, response.response)))
                } else {
                    promise(.failure(NetworkError.empty))
                }
            }
        }
        .eraseToAnyPublisher()
    }

}
