//
//  ColorExtension.swift
//  Extensions
//
//  Created by Amine Bensalah on 12/06/2019.
//  Copyright © 2019 BENSALA. All rights reserved.
//

import UIKit

public extension UIColor {
    convenience init(red: Int,
                     green: Int,
                     blue: Int,
                     alpha: CGFloat = 1.0) {
        self.init(red: CGFloat(red) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: alpha)
    }

    convenience init(hex: Int,
                     alpha: CGFloat = 1.0) {
        self.init(red: (hex >> 16) & 0xFF,
                  green: (hex >> 8) & 0xFF,
                  blue: hex & 0xFF,
                  alpha: alpha)
    }

    static var random: UIColor {
        UIColor(red: .random(in: 0 ... 1),
                green: .random(in: 0 ... 1),
                blue: .random(in: 0 ... 1),
                alpha: 1.0)
    }
}
