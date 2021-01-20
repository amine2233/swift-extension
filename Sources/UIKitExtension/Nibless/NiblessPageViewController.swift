//
//  NiblessPageViewController.swift
//  ApplicationDelegate
//
//  Created by Amine Bensalah on 25/06/2019.
//

import UIKit

open class NiblessPageViewController: UIPageViewController {
    // MARK: - Methods

    public init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    public override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey: Any]? = nil) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
    }

    @available(*, unavailable,
               message: "Loading this view controller from nib is unsupported in favor of initializer dependency injection")
    public required init?(coder _: NSCoder) {
        fatalError("Loading this view controller from nib is unsupported in favor of initializer dependency injection")
    }

    deinit {
        print("deinit => \(NiblessPageViewController.self)")
    }
}
