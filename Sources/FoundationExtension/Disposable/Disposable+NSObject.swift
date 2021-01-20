//
//  Disposable+NSObject.swift
//  Extensions
//
//  Created by Amine Bensalah on 28/05/2019.
//  Copyright © 2019 BENSALA. All rights reserved.
//

import Foundation

public protocol DisposableContainerProvider {
    var disposable: DisposeContainer { get }
}

extension NSObject: DisposableContainerProvider {
    private struct AssociatedKeys {
        static var DisposableKey = "DisposeBagKey"
    }

    public var disposable: DisposeContainer {
        if let disposeBag = objc_getAssociatedObject(self, &NSObject.AssociatedKeys.DisposableKey) {
            return disposeBag as! DisposeContainer
        } else {
            let disposeBag = DisposeContainer()
            objc_setAssociatedObject(
                self,
                &NSObject.AssociatedKeys.DisposableKey,
                disposeBag,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            return disposeBag
        }
    }
}
