//
//  URLResponseMock.swift
//  GrapeCI
//
//  Created by Ricardo Maqueda Martinez on 06/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import Foundation

class URLResponseMock {
    let invalidResponse = URLResponse(url: URL(string: "http://localhost:8080")!,
                                      mimeType: nil,
                                      expectedContentLength: 0,
                                      textEncodingName: nil)

    let validResponse = HTTPURLResponse(url: URL(string: "http://localhost:8080")!,
                                        statusCode: 200,
                                        httpVersion: nil,
                                        headerFields: nil)

    let invalidResponse300 = HTTPURLResponse(url: URL(string: "http://localhost:8080")!,
                                             statusCode: 300,
                                             httpVersion: nil,
                                             headerFields: nil)
    let invalidResponse401 = HTTPURLResponse(url: URL(string: "http://localhost:8080")!,
                                             statusCode: 401,
                                             httpVersion: nil,
                                             headerFields: nil)

    let networkError = NSError(domain: "NSURLErrorDomain", code: -1004, userInfo: nil)

}
