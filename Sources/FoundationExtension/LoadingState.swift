//
//  LoadingState.swift
//  Extensions
//
//  Created by BENSALA on 02/05/2019.
//  Copyright © 2019 BENSALA. All rights reserved.
//

import Foundation

public enum LoadindState<Resource, Failure: Error> {
    case idle
    case loading(Resource?)
    case loaded(Resource)
    case error(Failure, Resource?)
}

public extension LoadindState {
    var shouldHideLoadingView: Bool {
        switch self {
        case .idle: fatalError("Doesn't applay")
        case .loading(nil): return false
        case .loading(.some), .loaded, .error: return true
        }
    }

    var shouldHideErrorView: Bool {
        switch self {
        case .idle: fatalError("Doesn't applay")
        case .loading, .loaded: return true
        case .error(_, nil): return false
        case .error(_, .some): return true
        }
    }
}

public extension LoadindState where Resource: Collection {
    var shouldHideEmptyView: Bool {
        switch self {
        case .idle: fatalError("Doesn't applay")
        case .loading(nil): return false
        case let .loading(.some(value)), let .loaded(value): return !value.isEmpty
        case .error: return true
        }
    }
}
