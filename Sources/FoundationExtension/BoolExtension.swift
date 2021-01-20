//
//  BoolExtension.swift
//  lettresender
//
//  Created by Amine Bensalah on 04/12/2016.
//  Copyright © 2016 Amine Bensalah. All rights reserved.
//

import Foundation

public extension Bool {
    var toString: String {
        (self == true) ? "true" : "false"
    }

    func toogle() -> Bool {
        !self
    }
}
