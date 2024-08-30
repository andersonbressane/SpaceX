//
//  LaunchResponseModel.swift
//  Devskiller
//
//  Created by Anderson Franco on 30/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation
import RealmSwift

protocol LaunchResponseProtocol {
    var page: Int? { get }
    var hasNextPage: Bool? { get }
    var hasPrevPage: Bool? { get }
    var totalDocs: Int? { get }
    var limit: Int? { get }
    var nextPage: Int? { get }
    var prevPage: Int? { get }
    
    var docs: RealmSwift.List<LaunchModel> { get }
}

class LaunchResponseModel: Object, LaunchResponseProtocol, DataBaseModelProtocol {
    @Persisted var docs = RealmSwift.List<LaunchModel>()
    
    @Persisted var page: Int?
    @Persisted var hasNextPage: Bool?
    @Persisted var hasPrevPage: Bool?
    @Persisted var totalDocs: Int?
    @Persisted var limit: Int?
    @Persisted var nextPage: Int?
    @Persisted var prevPage: Int?
    
    static func convertFrom<T>(object: T) -> RealmSwift.Object? where T : Decodable, T : Encodable {
        guard let object = object as? LaunchResponse else { return nil }
        
        let launchResponse = LaunchResponseModel()
        
        launchResponse.page = object.page
        launchResponse.hasNextPage = object.hasNextPage
        launchResponse.hasPrevPage = object.hasPrevPage
        launchResponse.totalDocs = object.totalDocs
        launchResponse.limit = object.limit
        launchResponse.nextPage = object.nextPage
        launchResponse.prevPage = object.prevPage
        launchResponse.docs.append(objectsIn: object.docs.compactMap({ LaunchModel.convertFrom(object: $0) as? LaunchModel }))
        
        
        return launchResponse
    }
    
    func convertToCodable() -> (any Codable)? {
        return LaunchResponse(docs: self.docs.compactMap({ $0.convertToCodable() as? Launch }), page: self.page ?? 1, hasNextPage: self.hasNextPage, hasPrevPage: self.hasNextPage, totalDocs: self.totalDocs, limit: self.limit, nextPage: self.nextPage, prevPage: self.prevPage)
    }
}
