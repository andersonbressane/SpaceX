//
//  PatchModel.swift
//  Devskiller
//
//  Created by Anderson Franco on 30/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation
import RealmSwift

protocol PatchProtocol {
    var small: String? { get }
    var large: String? { get }
}

class PatchModel: Object, PatchProtocol, DataBaseModelProtocol  {
    @Persisted var small: String?
    @Persisted var large: String?
    
    static func convertFrom<T>(object: T) -> RealmSwift.Object? where T : Decodable, T : Encodable {
        guard let object = object as? Launch.Links.Patch else { return nil }
        
        let patchModel = PatchModel()
        
        patchModel.small = object.small
        patchModel.large = object.large
        
        return patchModel
    }
    
    func convertToCodable() -> Codable? {
        return Launch.Links.Patch(small: self.small, large: self.large)
    }
}
