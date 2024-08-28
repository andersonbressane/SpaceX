//
//  NetworkCombineClient.swift
//  Devskiller
//
//  Created by Anderson Franco on 24/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation
import Combine

class NetworkClient: NetworkClientProtocol {
    
    private var cancellables = Set<AnyCancellable>()
    
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
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { return completion(.failure(ErrorResult.invalidResponse)) }
            
            guard (200...299).contains(httpResponse.statusCode) else { return completion(.failure(ErrorResult.httpError(statusCode: httpResponse.statusCode))) }
            
            guard let data = data else { return completion(.failure(.noData))}
            
            log += "responseCode: \(httpResponse.statusCode)\n"
            
            log += "responseData:  \(String(data: data, encoding: String.Encoding.utf8) ?? "")\n"
            
            completion(.success(data))
        }.resume()
    }
    
    func dataTask(endpoint: EndpointProtocol) -> AnyPublisher<Data, ErrorResult> {
        guard let url = endpoint.url else { return Fail(error: ErrorResult.badURL).eraseToAnyPublisher() }
        
        var request = URLRequest(url: url, cachePolicy: endpoint.cachePolicy, timeoutInterval: endpoint.cacheTime)
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = 20
        
        var log = "\nNetwork: \nurl: \(request.url?.absoluteString ?? "")\nMethod: \(endpoint.method.rawValue)\n"
        
        if let postData = endpoint.parameters, let data = try? JSONSerialization.data(withJSONObject: postData, options: .withoutEscapingSlashes) {
            
            request.setValue(String(format: "%d", postData.count), forHTTPHeaderField: "Content-Length")
            request.setValue(endpoint.contentType, forHTTPHeaderField: "Content-Type")
            request.httpBody = data
            
            log += "httpBody: \(String(data: data, encoding: String.Encoding.utf8) ?? "")\n"
        }
        
        let responsePublisher = Future<Data, ErrorResult> { [weak self] promise in
            guard let self else { return }
            
            let requestPublisher = URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { output in
                    guard let httpResponse = output.response as? HTTPURLResponse else { throw ErrorResult.invalidResponse }
                    
                    guard (200...299).contains(httpResponse.statusCode) else { throw ErrorResult.httpError(statusCode: httpResponse.statusCode) }
                    
                    log += "responseCode: \(httpResponse.statusCode)\n"
                    
                    log += "responseData:  \(String(data: output.data, encoding: String.Encoding.utf8) ?? "")\n"
                    
                    print(log)
                    
                    return output.data
                }
                .mapError { error in
                    print(log)
                    return ErrorResult.unknown(error)
                }
                .eraseToAnyPublisher()
            
            requestPublisher.sink { completion in
                switch completion {
                case .finished:
                    ()
                case .failure(let error):
                    promise(.failure(error))
                }
            } receiveValue: { data in
                promise(.success(data))
            }
            .store(in: &cancellables)
        }
        
        return responsePublisher.eraseToAnyPublisher()
    }
}
