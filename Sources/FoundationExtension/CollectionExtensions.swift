//
//  CollectionExtensions.swift
//  Extensions
//
//  Created by Amine Bensalah on 03/05/2019.
//  Copyright © 2019 BENSALA. All rights reserved.
//

import Foundation

public extension Array {
    subscript(safe index: Int) -> Element? {
        index >= 0 && index < count ? self[index] : nil
    }
}

public extension Dictionary {
    subscript(i: Int) -> (key: Key, value: Value) {
        return self[index(startIndex, offsetBy: i)]
    }
}

public extension Set {
    var array: [Element] {
        Array(self)
    }

    subscript(safe index: Int) -> Element? {
        array[safe: index]
    }
}
