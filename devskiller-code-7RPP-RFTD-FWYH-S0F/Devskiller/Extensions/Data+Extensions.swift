//
//  Data+Extensions.swift
//  Devskiller
//
//  Created by Anderson Franco on 28/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation

extension Data {
    func toJSON() -> [String: Any]? {
        if let json = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers) as? [String: Any] {
            return json
        }
        
        return nil
    }
}
