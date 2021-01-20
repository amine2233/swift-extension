//
//  NiblessSplitViewController.swift
//  Extensions
//
//  Created by BENSALA on 14/05/2019.
//  Copyright © 2019 BENSALA. All rights reserved.
//

import UIKit

open class NiblessSplitViewController: UISplitViewController {
    // MARK: - Methods

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable,
               message: "Loading this view controller from nib is unsupported in favor of initializer dependency injection")
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable,
               message: "Loading this view controller from nib is unsupported in favor of initializer dependency injection")
    public required init?(coder _: NSCoder) {
        fatalError("Loading this view controller from nib is unsupported in favor of initializer dependency injection")
    }
}
