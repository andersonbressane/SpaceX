//
//  LinksModel.swift
//  Devskiller
//
//  Created by Anderson Franco on 30/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation
import RealmSwift

protocol LinksProtocol {
    var article: String? { get }
    var wikipedia: String? { get }
    var webcast: String? { get }
    var patch: PatchModel? { get }
}

class LinksModel: Object, LinksProtocol, DataBaseModelProtocol {
    @Persisted var article: String?
    @Persisted var wikipedia: String?
    @Persisted var webcast: String?
    @Persisted var patch: PatchModel?
    
    static func convertFrom<T>(object: T) -> RealmSwift.Object? where T : Decodable, T : Encodable {
        guard let object = object as? Launch.Links else { return nil }
        
        let linksModel = LinksModel()
        
        linksModel.article = object.article
        linksModel.wikipedia = object.wikipedia
        linksModel.webcast = object.webcast
        linksModel.patch = PatchModel.convertFrom(object: object.patch) as? PatchModel
        
        return linksModel
    }
    
    func convertToCodable() -> Codable? {
        return Launch.Links(
            article: self.article,
            wikipedia: self.wikipedia,
            webcast: self.webcast,
            patch: self.patch?.convertToCodable() as? Launch.Links.Patch)
    }
}
