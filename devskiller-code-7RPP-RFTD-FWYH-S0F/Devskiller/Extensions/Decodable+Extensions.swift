//
//  Decodable+Extensions.swift
//  Devskiller
//
//  Created by Anderson Franco on 28/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation

extension Decodable {
    static func decodeFrom(data: Data?) throws -> Self {
        guard let data = data else {
            throw ErrorResult.noData
        }

        do {
            let data = try JSONSerialization.data(withJSONObject: data)
            let decoder = JSONDecoder()
            let model = try decoder.decode(Self.self, from: data)
            return model

        } catch {
            throw ErrorResult.parsingError(object: "\(Self.self)")
        }
    }
}
