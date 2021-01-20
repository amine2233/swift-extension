//
//  MainWindow.swift
//  Binders
//
//  Created by BENSALA on 10/04/2019.
//  Copyright © 2019 BENSALA. All rights reserved.
//

import UIKit

public extension UIWindow {
    func reload() {
        subviews.forEach { view in
            view.removeFromSuperview()
            addSubview(view)
        }
    }
}

public extension Array where Element == UIWindow {
    func reload() {
        forEach { $0.reload() }
    }
}
