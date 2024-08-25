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
    
    func dataTask(endpoint: EndpointProtocol) -> AnyPublisher<Data, ErrorResult> {
        guard let url = endpoint.url else { return Fail(error: ErrorResult.badURL).eraseToAnyPublisher() }
        
        var request = URLRequest(url: url, cachePolicy: endpoint.cachePolicy, timeoutInterval: endpoint.cacheTime)
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = 20
        
        if let postData = endpoint.parameters, let data = try? JSONSerialization.data(withJSONObject: postData, options: .prettyPrinted) {
            
            request.setValue(String(format: "%d", postData.count), forHTTPHeaderField: "Content-Length")
            request.setValue(endpoint.contentType, forHTTPHeaderField: "Content-Type")
            request.httpBody = data
        }
        
        let responsePublisher = Future<Data, ErrorResult> { [weak self] promise in
            guard let self else { return }
            
            let publisher = URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { output in
                    guard let httpResponse = output.response as? HTTPURLResponse else { throw ErrorResult.invalidResponse }
                    
                    guard (200...299).contains(httpResponse.statusCode) else { throw ErrorResult.httpError(statusCode: httpResponse.statusCode) }
                    
                    return output.data
                }
                .mapError { error in
                    return ErrorResult.unknown(error)
                }
                .eraseToAnyPublisher()
            
            publisher.sink { completion in
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
