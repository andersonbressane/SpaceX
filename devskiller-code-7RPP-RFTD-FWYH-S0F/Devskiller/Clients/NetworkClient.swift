//
//  NetworkCombineClient.swift
//  Devskiller
//
//  Created by Anderson Franco on 24/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation

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
    case noResult
    case invalidResponse
    case parsingError(object: String)
    case httpError(statusCode: Int)
    case unknown(Error?)
    
    var message: String {
        switch self {
        case .noResult:
            "No result for this search"
        case .invalidClient:
            "Invalid network client"
        case .noNetworks:
            "No internet connnection"
        case .badURL:
            "The URL is malformed"
        case .noData:
            "No data resonse"
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
    func dataTask(endpoint: EndpointProtocol, completion: @escaping (Result<Data, ErrorResult>) -> Void)
}

class NetworkClient: NetworkClientProtocol {
    var urlSession: URLSessionProtocol?
    
    init(_ urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func dataTask(endpoint: EndpointProtocol, completion: @escaping (Result<Data, ErrorResult>) -> Void) {
        guard let url = endpoint.url else { return completion(.failure(.badURL)) }
        
        var request = URLRequest(url: url, cachePolicy: endpoint.cachePolicy, timeoutInterval: endpoint.cacheTime)
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = 20
        
        var log = "\nNetwork: \nurl: \(request.url?.absoluteString ?? "")\nMethod: \(endpoint.method.rawValue)\n"
        
        if let postData = endpoint.parameters, let data = try? JSONSerialization.data(withJSONObject: postData, options: .withoutEscapingSlashes) {
            
            request.setValue(String(format: "%d", postData.count), forHTTPHeaderField: "Content-Length")
            request.setValue(endpoint.contentType, forHTTPHeaderField: "Content-Type")
            request.httpBody = data
            
            log += "httpBody: \(String(data: data, encoding: String.Encoding.utf8) ?? "")\n"
            
            print(log)
        }
        
        DispatchQueue.global(qos: .background).async {
            self.urlSession?.dataTask(with: request) { data, response, error in
                
                DispatchQueue.main.async {
                    guard let httpResponse = response as? HTTPURLResponse else { return completion(.failure(ErrorResult.invalidResponse)) }
                    
                    guard let data = data else { return completion(.failure(ErrorResult.noData))}
                    
                    guard (200...299).contains(httpResponse.statusCode) else { return completion(.failure(ErrorResult.httpError(statusCode: httpResponse.statusCode))) }
                    
                    log += "responseCode: \(httpResponse.statusCode)\n"
                    
                    log += "responseData:  \(String(data: data, encoding: String.Encoding.utf8) ?? "")\n"
                    
                    print(log)
                    
                    completion(.success(data))
                }
            }.resume()
        }
    }
}
