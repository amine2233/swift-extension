//
//  AssociatedObjects.swift
//  Extensions
//
//  Created by BENSALA on 02/05/2019.
//  Copyright © 2019 BENSALA. All rights reserved.
//

import Foundation

public enum AssociationPolicy {
    case strong
    case copy
    case weak

    var objcPolicy: objc_AssociationPolicy {
        switch self {
        case .strong:
            return .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        case .copy:
            return .OBJC_ASSOCIATION_COPY_NONATOMIC
        case .weak:
            return .OBJC_ASSOCIATION_ASSIGN
        }
    }
}

public protocol AssociatedObjects: AnyObject {
    func associatedObject<T>(for key: UnsafeRawPointer) -> T?
    func setAssociatedObject<T>(_ object: T, for key: UnsafeRawPointer, policy: AssociationPolicy)
    func removeAssociatedObject<T>(_ object: T)
}

extension AssociatedObjects {
    public func associatedObject<T>(for key: UnsafeRawPointer) -> T? {
        objc_getAssociatedObject(self, key) as? T
    }

    public func setAssociatedObject<T>(_ object: T, for key: UnsafeRawPointer, policy: AssociationPolicy) {
        return objc_setAssociatedObject(object, key, object, policy.objcPolicy)
    }

    public func removeAssociatedObject<T>(_ object: T) {
        return objc_removeAssociatedObjects(object)
    }
}

extension NSObject: AssociatedObjects {}

/**********************************/
// New method for AssociatedObject
/**********************************/

private class Associated<T>: NSObject {
    let value: T
    init(_ value: T) {
        self.value = value
    }
}

public protocol Associable {}

public extension Associable where Self: AnyObject {
    func getAssociatedObject<T>(_ key: UnsafeRawPointer) -> T? {
        (objc_getAssociatedObject(self, key) as? Associated<T>).map { $0.value }
    }

    func setAssociatedObject<T>(_ key: UnsafeRawPointer, _ value: T?) {
        objc_setAssociatedObject(self, key, value.map { Associated<T>($0) }, .OBJC_ASSOCIATION_RETAIN)
    }
}

extension NSObject: Associable {}
