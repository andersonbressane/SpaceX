//
//  ViewModelProtocol.swift
//  Devskiller
//
//  Created by Anderson Franco on 25/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation

enum LoadState {
    case none
    case loading
    case success(message: String?)
    case error(message: String?)
}

protocol ViewModelProtocol {
    var loadState: LoadState { get set }
}

extension ViewModelProtocol {
    var loadState: LoadState {
        LoadState.none
    }
}
