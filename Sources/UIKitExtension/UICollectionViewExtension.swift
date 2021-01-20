//
//  UICollectionViewExtensions.swift
//  Extensions
//
//  Created by BENSALA on 13/05/2019.
//  Copyright © 2019 BENSALA. All rights reserved.
//

import UIKit

public extension UICollectionView {
    func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: "\(T.self)")
    }

    func register<T: UICollectionViewCell>(_ cellClasses: [T.Type]) {
        cellClasses.forEach { register($0) }
    }

    func dequeueReusableCell<T: UICollectionViewCell>(withType _: T.Type, for indexPath: IndexPath) -> T? {
        dequeueReusableCell(withReuseIdentifier: "\(T.self)", for: indexPath) as? T
    }

    func register<T: UICollectionReusableView>(_ viewHeaderFooterClass: T.Type) {
        register(viewHeaderFooterClass, forSupplementaryViewOfKind: "\(T.self)", withReuseIdentifier: "\(T.self)")
    }

    func register<T: UICollectionReusableView>(_ viewHeaderFooterClasses: [T.Type]) {
        viewHeaderFooterClasses.forEach { register($0) }
    }

    func dequeueReusableReusableView<T: UICollectionReusableView>(withType _: T.Type, for indexPath: IndexPath) -> T? {
        dequeueReusableSupplementaryView(ofKind: "\(T.self)", withReuseIdentifier: "\(T.self)", for: indexPath) as? T
    }
}

public extension UICollectionView {
    func reloadData(completion: @escaping () -> Swift.Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
}
