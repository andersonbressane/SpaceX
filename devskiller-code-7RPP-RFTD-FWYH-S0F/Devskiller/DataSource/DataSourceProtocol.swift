//
//  DataSourceProtocol.swift
//  Devskiller
//
//  Created by Anderson Franco on 25/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation
import Combine

protocol DataSourceProtocol {
    var cancellables: Set<AnyCancellable> { get }
}


