//
//  UIViewControllerErrors.swift
//  Extensions
//
//  Created by BENSALA on 14/05/2019.
//  Copyright © 2019 BENSALA. All rights reserved.
//

import UIKit

public extension UIViewController {
    @discardableResult
    func present(errorMessage: String, completion: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController.makeDefaultAlertController(title: "Error", message: errorMessage, cancelHandler: { _ in
            completion?()
        })
        present(alert, animated: true, completion: nil)
        return alert
    }
}
