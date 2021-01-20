//
//  NSObjectProtocolExtension.swift
//  Extensions
//
//  Created by BENSALA on 25/04/2019.
//  Copyright © 2019 BENSALA. All rights reserved.
//

import Foundation

public protocol KeyPathSelfProtocol {}

public extension KeyPathSelfProtocol {
    var keyPathSelf: Self {
        get { self }
        set { self = newValue }
    }
}

extension NSObject: KeyPathSelfProtocol {}

public extension NSObjectProtocol where Self: NSObject {
    func observe<Value>(_ keyPath: KeyPath<Self, Value>,
                        onChange: @escaping (Value) -> Void) -> Disposable {
        let observation = observe(keyPath, options: [.initial, .new]) { _, change in
            // The guard is because of https://bugs.swift.org/browse/SR-6066
            guard let newValue = change.newValue else { return }
            onChange(newValue)
        }
        return BlockDisposable { observation.invalidate() }
    }
    
    func observe<Value>(_ keyPath: KeyPath<Self, Value>,
                        onChange: @escaping (Self, Value) -> Void) -> Disposable {
        let observer = observe(keyPath, options: [.initial, .new]) { _, change in
            // The guard is because of https://bugs.swift.org/browse/SR-6066
            guard let newValue = change.newValue else { return }
            onChange(self, newValue)
        }
        return BlockDisposable { observer.invalidate() }
    }
    
    func observe<Value, Target>(to bindable: Target,
                                keyPath: KeyPath<Self, Value>,
                                onChange: @escaping (Target, Value) -> Void) -> Disposable {
        let observation = observe(keyPath, options: [.initial, .new]) { _, change in
            // The guard is because of https://bugs.swift.org/browse/SR-6066
            guard let newValue = change.newValue else { return }
            onChange(bindable, newValue)
        }
        return BlockDisposable { observation.invalidate() }
    }
    
    func observe<Value, Target: AnyObject>(to bindable: Target,
                                           keyPath: KeyPath<Self, Value>,
                                           onChange: @escaping (Target, Value) -> Void) -> Disposable {
        let observation = observe(keyPath, options: [.initial, .new]) { [weak bindable] _, change in
            // The guard is because of https://bugs.swift.org/browse/SR-6066
            guard let newValue = change.newValue else { return }
            guard let bindable = bindable else { return }
            onChange(bindable, newValue)
        }
        return BlockDisposable { observation.invalidate() }
    }
}

extension NSObjectProtocol {
    /// Same as retain(), which the compiler no longer lets us call:
    @discardableResult
    func retainMe() -> Self {
        _ = Unmanaged.passRetained(self)
        return self
    }
    
    /// Same as autorelease(), which the compiler no longer lets us call.
    ///
    /// This function does an autorelease() rather than release() to give you more flexibility.
    @discardableResult
    func releaseMe() -> Self {
        _ = Unmanaged.passUnretained(self).autorelease()
        return self
    }
}
