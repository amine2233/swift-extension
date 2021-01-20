//
//  UIAlertViewControllerExtension.swift
//  Extensions
//
//  Created by BENSALA on 14/05/2019.
//  Copyright © 2019 BENSALA. All rights reserved.
//

import UIKit

public extension UIAlertController {
    static func makeDefaultAlertController(title: String? = nil,
                                           message: String,
                                           cancelHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: cancelHandler))
        return alertController
    }

    static func makeRetrayAlertController(title: String? = nil,
                                          message: String,
                                          retryHandler: ((UIAlertAction) -> Void)?,
                                          cancelHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Retry", style: .cancel, handler: retryHandler))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: cancelHandler))
        return alertController
    }

    static func makeRemoveAlertController(title: String? = nil,
                                          message: String,
                                          removeHandler: ((UIAlertAction) -> Void)?,
                                          cancelHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: removeHandler))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: cancelHandler))
        return alertController
    }

    static func makeErrorAlertController(title: String = "Error",
                                         error: Error,
                                         retryHandler: ((UIAlertAction) -> Void)? = nil,
                                         cancelHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        if let retryHandler = retryHandler {
            alertController.addAction(UIAlertAction(title: "Retry", style: .cancel, handler: retryHandler))
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: cancelHandler))
        return alertController
    }
}
