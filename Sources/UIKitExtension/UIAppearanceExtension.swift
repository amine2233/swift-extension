//
//  File.swift
//  Extensions
//
//  Created by BENSALA on 25/04/2019.
//  Copyright © 2019 BENSALA. All rights reserved.
//

import UIKit

public extension UIAppearance {
    @discardableResult
    func style(_ styleClosure: (Self) -> Swift.Void) -> Self {
        styleClosure(self)
        return self
    }
}
