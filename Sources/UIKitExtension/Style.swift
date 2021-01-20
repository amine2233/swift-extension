//
//  Style.swift
//  Extensions
//
//  Created by BENSALA on 26/04/2019.
//  Copyright © 2019 BENSALA. All rights reserved.
//

import UIKit

public struct Style<View: UIView> {
    public let style: (View) -> Void

    public init(style: @escaping (View) -> Void) {
        self.style = style
    }

    /// Applies self to the view.
    public func apply(to view: View) {
        style(view)
    }

    /// Style that does nothing (keeps the default/native style).
    public static var native: Style<View> {
        Style { _ in }
    }
}

public extension UIView {
    /// For example: `let nameLabel = UILabel(style: Stylesheet.Profile.name)`.
    convenience init<V>(style: Style<V>) {
        self.init(frame: .zero)
        apply(style)
    }

    /// Applies the given style to self.
    func apply<V>(_ style: Style<V>) {
        guard let view = self as? V else {
            print("💥 Could not apply style for \(V.self) to \(type(of: self))")
            return
        }

        style.apply(to: view)
    }

    /// Returns self with the style applied. For example: `let nameLabel = UILabel().styled(with: Stylesheet.Profile.name)`.
    func styled<V>(with style: Style<V>) -> Self {
        guard let view = self as? V else {
            print("💥 Could not apply style for \(V.self) to \(type(of: self))")
            return self
        }
        style.apply(to: view)
        return self
    }
}

public extension Style {
    /// Marges two styles together.
    func adding<V>(_ other: Style<V>) -> Style {
        Style {
            self.apply(to: $0)
            other.apply(to: $0 as! V)
        }
    }

    /// Returns current style modified by the given closure.
    func modifying(_ other: @escaping (View) -> Void) -> Style {
        Style {
            self.apply(to: $0)
            other($0)
        }
    }
}
