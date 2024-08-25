//
//  LaunchesEndPoint.swift
//  Devskiller
//
//  Created by Anderson Franco on 24/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation

class LaunchEndpoint: EndpointProtocol {
    var cacheTime: TimeInterval {
        TimeInterval(TWENTY_SECONDS)
    }
    
    var parameters: [String : Any]?
    
    var method: HttpMethod {
        switch actionEnum {
        case .getLaunches:
            .Get
        case .queryLaunches:
            .Post
        }
    }
    
    var cachePolicy: NSURLRequest.CachePolicy {
        .reloadRevalidatingCacheData
    }
    
    var url: URL? {
        guard var urlComponent = URLComponents(string: API_BASE_URL) else { return nil }
        
        switch actionEnum {
        case .getLaunches:
            urlComponent.path.append(API_LAUNCHES_URL)
        case .queryLaunches:
            urlComponent.path.append(API_LAUNCHES_QUERY_URL)
            
            if self.contentType == HTTPBodyContentType.urlEncoded, let query = parameters?.compactMap({ URLQueryItem(name: $0.key, value: String(describing: $0.value)) }) {
                urlComponent.queryItems = query
            }
        }
        
        return urlComponent.url
    }
    
    var contentType: String {
        switch actionEnum {
        case .getLaunches:
            HTTPBodyContentType.urlEncoded
        case .queryLaunches:
            HTTPBodyContentType.json
        }
    }
    
    enum ActionEnum {
        case getLaunches
        case queryLaunches
    }
    
    let actionEnum: ActionEnum
    
    init(_ actionEnum: ActionEnum, parameters: [String: Any]? = nil) {
        self.actionEnum = actionEnum
        self.parameters = parameters
    }
}
