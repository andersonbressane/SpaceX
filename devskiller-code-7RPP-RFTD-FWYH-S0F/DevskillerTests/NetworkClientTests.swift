//
//  NetworkClientTests.swift
//  DevskillerTests
//
//  Created by Anderson Franco on 29/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import XCTest
@testable import Devskiller

class NetworkClientTests: XCTestCase {
    var networkClient: NetworkClient!
    var urlSessionMock: URLSessionProtocol!
    
    override func setUp() {
        super.setUp()
        let urlSessionMock = URLSessionMock()
        networkClient = NetworkClient(urlSessionMock)
    }
    
    func testBadURL() {
        let endpoint = MockEndpoint(url: nil)
        let expectation = self.expectation(description: "Bad URL error")
        networkClient.dataTask(endpoint: endpoint) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.message, ErrorResult.badURL.message)
            case .success:
                XCTFail("Expected failure but got success")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testNoDataResponse() {
        let endpoint = MockEndpoint(url: URL(string: "https://asdsad.ads"))
        
        let mockURLSession = URLSessionMock()
        mockURLSession.data = nil
        
        let expectation = self.expectation(description: "No data invalid response error")
        
        NetworkClient(mockURLSession).dataTask(endpoint: endpoint) { result in
            switch result {
                
            case .failure(let error):
                XCTAssertEqual(error.message, ErrorResult.invalidResponse.message)
            case .success(_):
                XCTFail("Expected failure but got success")
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testInvalidResponse() {
        let endpoint = MockEndpoint(url: URL(string: "https://example.com"))
        
        let mockURLSession = URLSessionMock()
        mockURLSession.response = nil
        
        let expectation = self.expectation(description: "Invalid response error")
        
        networkClient.urlSession = mockURLSession
        networkClient.dataTask(endpoint: endpoint) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.message, ErrorResult.invalidResponse.message)
            case .success:
                XCTFail("Expected failure but got success")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}

class MockEndpoint: EndpointProtocol {
    var url: URL?
    var method: HttpMethod
    var parameters: [String: Any]?
    var contentType: String
    var cachePolicy: URLRequest.CachePolicy
    var cacheTime: TimeInterval
    
    init(url: URL?, method: HttpMethod = .Get, parameters: [String: Any]? = nil, contentType: String = HTTPBodyContentType.json, cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy, cacheTime: TimeInterval = 60) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.contentType = contentType
        self.cachePolicy = cachePolicy
        self.cacheTime = cacheTime
    }
}

class URLSessionMock: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let data = self.data
        let response = self.response
        let error = self.error
        return URLSessionDataTaskMock {
            completionHandler(data, response, error)
        }
    }
}

class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    override func resume() {
        closure()
    }
}
