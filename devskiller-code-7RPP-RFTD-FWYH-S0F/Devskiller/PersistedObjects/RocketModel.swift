//
//  RocketModel.swift
//  Devskiller
//
//  Created by Anderson Franco on 30/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation
import RealmSwift

protocol RocketProtocol {
    var name: String? { get }
    var type: String? { get }
}

class RocketModel: Object, RocketProtocol, DataBaseModelProtocol  {
    @Persisted var name: String?
    @Persisted var type: String?
    
    static func convertFrom<T>(object: T) -> RealmSwift.Object? where T : Decodable, T : Encodable {
        guard let object = object as? Launch.Rocket else { return nil }
        
        let rocketModel = RocketModel()
        
        rocketModel.name = object.name
        rocketModel.type = object.type
        
        return rocketModel
    }
    
    func convertToCodable() -> Codable? {
        return Launch.Rocket(name: self.name, type: self.type)
    }
}
    
