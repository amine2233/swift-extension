//
//  KeyPath.swift
//  Extensions
//
//  Created by BENSALA on 02/05/2019.
//  Copyright © 2019 BENSALA. All rights reserved.
//

import Foundation

public extension Sequence {
    func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        map { $0[keyPath: keyPath] }
    }
}

public extension Sequence {
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        sorted { left, right in
            left[keyPath: keyPath] < right[keyPath: keyPath]
        }
    }
}

public func setter<Object: AnyObject, Value>(for object: Object, keyPath: ReferenceWritableKeyPath<Object, Value>)
    -> (Value) -> Swift.Void {
    return { [weak object] value in
        object?[keyPath: keyPath] = value
    }
}
