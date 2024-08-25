//
//  AFCompanyEndpoint.swift
//  Devskiller
//
//  Created by Anderson Franco on 24/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation

class CompanyEndpoint: EndpointProtocol {
    var cacheTime: TimeInterval {
        TimeInterval(TWENTY_FOUR_HOURS)
    }
    
    var url: URL? {
        guard var urlComponent = URLComponents(string: API_BASE_URL) else { return nil }
        
        switch actionEnum {
        case .getCompany:
            urlComponent.path.append(API_COMPANY_URL)
        }
        
        return urlComponent.url
    }
    var contentType: String {
        HTTPBodyContentType.urlEncoded
    }
    
    var method: HttpMethod {
        .Get
    }
    
    var cachePolicy: NSURLRequest.CachePolicy {
        .reloadRevalidatingCacheData
    }
    
    var parameters: [String : Any]?
    
    enum ActionEnum {
        case getCompany
    }
    
    let actionEnum: ActionEnum
    
    init(actionEnum: ActionEnum, parameters: [String : Any]? = nil) {
        self.parameters = parameters
        self.actionEnum = actionEnum
    }
}
