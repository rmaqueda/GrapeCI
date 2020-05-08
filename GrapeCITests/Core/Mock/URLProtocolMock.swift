//
//  URLProtocolMock.swift
//  CombineAPIDemo
//
//  Created by Andrea Scuderi on 03/09/2019.
//

import Foundation

//References:
//  --: https://www.hackingwithswift.com/articles/153/how-to-test-ios-networking-code-the-easy-way
//  --: https://nshipster.com/nsurlprotocol/

@objc class URLProtocolMock: URLProtocol {
    static var testURLs = [String: Data]()
    static var response: URLResponse?
    static var error: Error?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canInit(with task: URLSessionTask) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let url = request.url {

            var noParams = url.absoluteString.replacingOccurrences(of: url.query ?? "", with: "")
            noParams = noParams.replacingOccurrences(of: "?", with: "")

            if let data = URLProtocolMock.testURLs[noParams] {
                client?.urlProtocol(self, didLoad: data)
            }
        }

        if let response = URLProtocolMock.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }

        if let error = URLProtocolMock.error {
            client?.urlProtocol(self, didFailWithError: error)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    // this method is required but doesn't need to do anything
    override func stopLoading() {

    }
    
}
