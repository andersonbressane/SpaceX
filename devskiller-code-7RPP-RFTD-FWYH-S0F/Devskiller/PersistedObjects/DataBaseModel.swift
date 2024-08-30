//
//  DataBaseModel.swift
//  Devskiller
//
//  Created by Anderson Franco on 30/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation
import RealmSwift

protocol DataBaseModelProtocol: Object {
    static func convertFrom<T: Codable>(object: T) -> Object?
    func convertToCodable() -> Codable?
}
