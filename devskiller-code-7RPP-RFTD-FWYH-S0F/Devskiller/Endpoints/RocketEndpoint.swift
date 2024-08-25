//
//  AFRocketEndpoint.swift
//  Devskiller
//
//  Created by Anderson Franco on 24/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation

class RocketEndpoint: EndpointProtocol {
    var cacheTime: TimeInterval {
        TimeInterval(TWENTY_FOUR_HOURS)
    }
    
    var url: URL? {
        guard var urlComponent = URLComponents(string: API_BASE_URL) else { return nil }
        
        switch actionEnum {
        case .getRocket(let id):
            urlComponent.path.append("\(API_ROCKET_ID_URL)\(id)")
        }
        
        return urlComponent.url
    }
    
    var method: HttpMethod {
        switch actionEnum {
        case .getRocket(_):
            .Get
        }
    }
    
    var cachePolicy: NSURLRequest.CachePolicy {
        .reloadRevalidatingCacheData
    }
    
    var parameters: [String : Any]?
    
    enum ActionEnum {
        case getRocket(id: String)
    }
    
    let actionEnum: ActionEnum
    
    init(actionEnum: ActionEnum, parameters: [String : Any]? = nil) {
        self.parameters = parameters
        self.actionEnum = actionEnum
    }
}
