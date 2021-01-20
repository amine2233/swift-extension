//
//  UIViewExtension.swift
//  Extensions
//
//  Created by Amine Bensalah on 24/05/2019.
//  Copyright © 2019 BENSALA. All rights reserved.
//

import UIKit

public extension UIView {
    func addInFullView(_ view: UIView, insets: UIEdgeInsets = .zero) {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: insets.bottom),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: insets.right)
        ])
    }

    func addInFullSafeView(_ view: UIView, insets: UIEdgeInsets = .zero) {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: insets.top),
            view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: insets.bottom),
            view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: insets.left),
            view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: insets.right)
        ])
    }

    func addInCenterView(_ view: UIView) {
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func addSizeConstraint(size: CGSize = .zero) {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ])
    }
}

public extension UIView {
    private func flipViews(fromView: UIView, toView: UIView) {
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]

        UIView.transition(from: fromView, to: toView, duration: 1, options: transitionOptions) { _ in
            fromView.isUserInteractionEnabled = false
            toView.isUserInteractionEnabled = true
        }
    }

    func flip(from: UIView? = nil, to: UIView) {
        flipViews(fromView: from ?? self, toView: to)
    }

    func shake() {
        let shake: CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true

        let fromPoint: CGPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue: NSValue = NSValue(cgPoint: fromPoint)

        let toPoint: CGPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue: NSValue = NSValue(cgPoint: toPoint)

        shake.fromValue = fromValue
        shake.toValue = toValue
        layer.add(shake, forKey: "position")
    }

    func addShadowAndRadius(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float, cornerRadius: CGFloat) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.cornerRadius = cornerRadius

        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor = backgroundCGColor
    }
}

public extension UIView {
    // Spring Animation
    static func springAnimate(duration: TimeInterval = 1.0, animateCompletion: @escaping () -> Void, finishCompletion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: animateCompletion, completion: finishCompletion)
    }
}

// MARK: Create view from Nib

public extension UIView {
    func getNibView(named nibName: String? = nil) -> UIView {
        createNibView(named: nibName)
    }

    func addSubviewFromNib(named nibName: String? = nil) {
        let view = createNibView(named: nibName)
        view.frame = bounds
        addSubview(view)
    }

    private func createNibView(named nibName: String? = nil) -> UIView {
        let bundle = Bundle(for: classForCoder)

        if let nibName = nibName {
            return bundle.loadNibNamed(nibName, owner: self, options: nil)!.last as! UIView
        } else {
            let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
            return nib.instantiate(withOwner: self, options: nil).first as! UIView
        }
    }

    class func fromNib<T: UIView>() -> T {
        Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

public extension UIView {
    /// Set some or all corners radiuses of view.
    ///
    /// - Parameters:
    ///   - corners: array of corners to change (example: [.bottomLeft, .topRight]).
    ///   - radius: radius for selected corners.
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )

        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}
