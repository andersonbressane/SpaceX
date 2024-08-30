//
//  LaunchModel.swift
//  Devskiller
//
//  Created by Anderson Franco on 30/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation
import RealmSwift

protocol LaunchProtocol {
    var name: String? { get }
    var details: String? { get }
    var dateLocal: String? { get }
    var dateUnix: TimeInterval? { get }
    var dateUTC: String? { get }
    var success: Bool? { get }
    var rocket: RocketModel? { get }
    var links: LinksModel? { get }
}

class LaunchModel: Object, LaunchProtocol, DataBaseModelProtocol {
    @Persisted var name: String?
    @Persisted var details: String?
    @Persisted var dateLocal: String?
    @Persisted var dateUnix: TimeInterval?
    @Persisted var dateUTC: String?
    @Persisted var success: Bool?
    @Persisted var rocket: RocketModel?
    @Persisted var links: LinksModel?
    
    static func convertFrom<T>(object: T) -> RealmSwift.Object? where T : Decodable, T : Encodable {
        guard let object = object as? Launch else { return nil }
        let launchModel = LaunchModel()
        
        launchModel.name = object.name
        launchModel.details = object.details
        launchModel.dateLocal = object.dateLocal
        launchModel.dateUnix = object.dateUnix
        launchModel.dateUTC = object.dateUTC
        launchModel.success = object.success
        launchModel.rocket = RocketModel.convertFrom(object: object.rocket) as? RocketModel
        launchModel.links = LinksModel.convertFrom(object: object.links) as? LinksModel
        
        return launchModel
    }
    
    func convertToCodable() -> (any Codable)? {
        return Launch(
            name: self.name,
            details: self.details,
            dateLocal: self.dateLocal,
            dateUnix: self.dateUnix,
            dateUTC: self.dateUTC,
            success: self.success,
            rocket: self.rocket?.convertToCodable() as? Launch.Rocket,
            links: self.links?.convertToCodable() as? Launch.Links)
    }
}
