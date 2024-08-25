//
//  APIEndPointProtocol.swift
//  Devskiller
//
//  Created by Anderson Franco on 24/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation
import UIKit

protocol EndpointProtocol {
    var url: URL? { get }
    var method: HttpMethod { get }
    var cachePolicy: NSURLRequest.CachePolicy { get }
    var parameters: [String: Any]? { get }
    var cacheTime: TimeInterval { get }
    var contentType: String { get }
}

extension EndpointProtocol {
    var contentType: String {
        HTTPBodyContentType.urlEncoded
    }
}

enum HttpMethod: String {
    case Post = "POST"
    case Get = "GET"
    case Put = "PUT"
    case Delete = "DELETE"
}
