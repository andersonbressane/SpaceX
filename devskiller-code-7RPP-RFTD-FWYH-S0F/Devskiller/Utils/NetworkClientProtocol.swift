//
//  HttpClient.swift
//  Devskiller
//
//  Created by Anderson Franco on 23/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//
import Foundation
import Combine

enum HTTPBodyContentType {
    static let urlEncoded = "application/x-www-form-urlencoded; charset=utf-8"
    static let json = "application/json; charset=utf-8"
}

protocol AFErrorProtocol: Error {
    var message: String { get }
}

enum ErrorResult: Error {
    case noMoreData
    case invalidClient
    case noNetworks
    case badURL
    case noData
    case invalidResponse
    case parsingError(object: String)
    case httpError(statusCode: Int)
    case unknown(Error?)
    
    var message: String {
        switch self {
        case .invalidClient:
            "Invalid network client"
        case .noNetworks:
            "No intenet connnection"
        case .badURL:
            "The URL is malformed"
        case .noData:
            "No data"
        case .invalidResponse:
            "Invalid response"
        case .httpError(let responseCode):
            "HTTP error code: \(responseCode)"
        case .unknown(let error):
            "Unknown error: \(error?.localizedDescription ?? "")"
        case .noMoreData:
            "No more data available"
        case .parsingError(let object):
            "It was not possible to parse \(object)"
        }
    }
}

protocol NetworkClientProtocol {
    func dataTask(endpoint: EndpointProtocol) -> AnyPublisher<Data, ErrorResult>
}
