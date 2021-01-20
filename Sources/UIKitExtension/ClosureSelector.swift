//
//  ClosureSelector.swift
//  Extensions
//
//  Created by BENSALA on 25/04/2019.
//  Copyright © 2019 BENSALA. All rights reserved.
//

import Foundation
import UIKit

public class ClosureSelector<T> {
    public let selector: Selector
    private let closure: (T) -> Swift.Void
    
    public init(_ closure: @escaping (T) -> Swift.Void) {
        selector = #selector(ClosureSelector.target(_:))
        self.closure = closure
    }
    
    @objc
    private func target(_ parm: AnyObject) {
        if let parm = parm as? T {
            closure(parm)
        }
    }
}

public class ClosureSelectorBind<N, T> {
    public let selector: Selector
    private let closure: (N, T) -> Swift.Void
    private let object: N
    
    public init(to object: N, closure: @escaping (N, T) -> Swift.Void) {
        selector = #selector(ClosureSelectorBind<AnyObject, AnyObject>.target(_:))
        self.closure = closure
        self.object = object
    }
    
    @objc
    private func target(_ parm: AnyObject) {
        if let parm = parm as? T {
            closure(object, parm)
        }
    }
}

public class ClosureSelectorKeyPath<T, Target> {
    public let selector: Selector
    private let closure: (T) -> Swift.Void
    private let keyPath: KeyPath<Target, T>
    
    public init(keyPath: KeyPath<Target, T>, closure: @escaping (T) -> Swift.Void) {
        selector = #selector(ClosureSelectorKeyPath<AnyObject, AnyObject>.target(_:))
        self.keyPath = keyPath
        self.closure = closure
    }
    
    @objc
    private func target(_ parm: AnyObject) {
        if let parm = parm as? Target {
            let value = parm[keyPath: keyPath]
            closure(value)
        }
    }
}

public class ClosureSelectorBindKeyPath<N, T, Target> {
    public let selector: Selector
    private let closure: (N, T) -> Swift.Void
    private let keyPath: KeyPath<Target, T>
    private let object: N
    
    public init(to object: N, keyPath: KeyPath<Target, T>, closure: @escaping (N, T) -> Swift.Void) {
        selector = #selector(ClosureSelectorBindKeyPath<AnyObject, AnyObject, AnyObject>.target(_:))
        self.keyPath = keyPath
        self.closure = closure
        self.object = object
    }
    
    @objc
    private func target(_ parm: AnyObject) {
        if let parm = parm as? Target {
            let value = parm[keyPath: keyPath]
            closure(object, value)
        }
    }
}

public class ClosureNotification<T> {
    public let selector: Selector
    private let notification = NotificationCenter.default
    private let closure: (T) -> Swift.Void
    private let notificationName: NSNotification.Name
    
    public init(_ target: T, notificationName: NSNotification.Name, closure: @escaping (T) -> Swift.Void) {
        selector = #selector(target(_:))
        self.closure = closure
        self.notificationName = notificationName
        notification.addObserver(self, selector: selector, name: self.notificationName, object: target)
    }
    
    @objc
    private func target(_ notification: Notification) {
        if let object = notification.object as? T {
            closure(object)
        }
    }
    
    deinit {
        notification.removeObserver(self, name: self.notificationName, object: self)
    }
}

public class ClosureNotificationKeyPath<T, Target> {
    public let selector: Selector
    private let notification = NotificationCenter.default
    private let closure: (T) -> Swift.Void
    private let keyPath: KeyPath<Target, T>
    private let notificationName: NSNotification.Name
    
    public init(_ target: Target, keyPath: KeyPath<Target, T>, notificationName: NSNotification.Name, closure: @escaping (T) -> Swift.Void) {
        selector = #selector(target(_:))
        self.closure = closure
        self.keyPath = keyPath
        self.notificationName = notificationName
        notification.addObserver(self, selector: selector, name: notificationName, object: target)
    }
    
    @objc
    private func target(_ notification: Notification) {
        if let object = notification.object as? Target {
            let valueKeyPath = object[keyPath: keyPath]
            closure(valueKeyPath)
        }
    }
    
    deinit {
        notification.removeObserver(self, name: notificationName, object: self)
    }
}

private var handle: Int = 0
private var handleBind: Int = 0
private var handleClosure: Int = 0
private var handleClosureBind: Int = 0

public extension NSObjectProtocol where Self: UIControl {
    @discardableResult
    func addTarget(forControlEvents controlEvents: UIControl.Event, withClosure closure: @escaping (Self) -> Void) -> Self {
        let closureSelector = ClosureSelector<Self>(closure)
        objc_setAssociatedObject(self, UnsafeRawPointer(UnsafeMutablePointer<UInt8>.allocate(capacity: 1)), closureSelector, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        addTarget(closureSelector, action: closureSelector.selector, for: controlEvents)
        return self
    }
    
    @discardableResult
    func addTarget<Value>(forControlEvents controlEvents: UIControl.Event, keyPath: KeyPath<Self, Value>, withClosure closure: @escaping (Value) -> Void) -> Self {
        let closureSelector = ClosureSelectorKeyPath(keyPath: keyPath, closure: closure)
        objc_setAssociatedObject(self, &handleClosure, closureSelector, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        addTarget(closureSelector, action: closureSelector.selector, for: controlEvents)
        return self
    }
    
    @discardableResult
    func bindTarget<T, Value>(to object: T, forControlEvents controlEvents: UIControl.Event, withClosure closure: @escaping (T, Value) -> Void) -> Self {
        let closureSelector = ClosureSelectorBind(to: object, closure: closure)
        objc_setAssociatedObject(self, &handleClosure, closureSelector, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        addTarget(closureSelector, action: closureSelector.selector, for: controlEvents)
        return self
    }
    
    @discardableResult
    func bindTarget<T, Value>(to object: T, forControlEvents controlEvents: UIControl.Event, keyPath: KeyPath<Self, Value>, withClosure closure: @escaping (T, Value) -> Void) -> Self {
        let closureSelector = ClosureSelectorBindKeyPath(to: object, keyPath: keyPath, closure: closure)
        objc_setAssociatedObject(self, &handleClosure, closureSelector, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        addTarget(closureSelector, action: closureSelector.selector, for: controlEvents)
        return self
    }
}

private var handleBarItem: Int = 0

public extension NSObjectProtocol where Self: UIBarButtonItem {
    func addAction(_ closure: @escaping (Self) -> Void) {
        let closureSelector = ClosureSelector<Self>(closure)
        objc_setAssociatedObject(self, &handleBarItem, closureSelector, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        target = closureSelector
        action = closureSelector.selector
    }
}

private var handleUITextView: Int = 0
private var handleUITextViewMap: Int = 0
private var handleUITextViewDidChangeNotification: Int = 0
// swiftlint:disable identifier_name
private var handleUITextViewDidEndEditingNotification: Int = 0
private var handleUITextViewDidBeginEditingNotification: Int = 0
// swiftlint:enable identifier_name

public extension NSObjectProtocol where Self: UITextView {
    func bindTextDidChange<Value, Target: AnyObject>(_ sourceKeyPath: KeyPath<Self, Value>,
                                                     to target: Target,
                                                     at targetKeyPath: ReferenceWritableKeyPath<Target, Value>) {
        let closureNotification = ClosureNotificationKeyPath(self, keyPath: sourceKeyPath, notificationName: UITextView.textDidChangeNotification) { [weak target] value in
            target?[keyPath: targetKeyPath] = value
        }
        objc_setAssociatedObject(self, &handleUITextView, closureNotification, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func bindTextDidChangeMap<Value, NewValue, Target: AnyObject>(_ sourceKeyPath: KeyPath<Self, Value>,
                                                                  to target: Target,
                                                                  at targetKeyPath: ReferenceWritableKeyPath<Target, NewValue>,
                                                                  transform: @escaping (Value) -> NewValue) {
        let closureNotification = ClosureNotificationKeyPath(self, keyPath: sourceKeyPath, notificationName: UITextView.textDidChangeNotification) { [weak target] value in
            target?[keyPath: targetKeyPath] = transform(value)
        }
        objc_setAssociatedObject(self, &handleUITextViewMap, closureNotification, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func textDidChange(_ closure: @escaping (Self) -> Void) {
        let closureNotification = ClosureNotification(self, notificationName: UITextView.textDidChangeNotification, closure: closure)
        objc_setAssociatedObject(self, &handleUITextViewDidChangeNotification, closureNotification, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func textDidChange<Value>(_ keyPath: KeyPath<Self, Value>,
                              closure: @escaping (Value) -> Void) {
        let closureNotification = ClosureNotificationKeyPath(self, keyPath: keyPath, notificationName: UITextView.textDidChangeNotification, closure: closure)
        objc_setAssociatedObject(self, &handleUITextViewDidChangeNotification, closureNotification, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func textDidEndEditing(_ closure: @escaping (Self) -> Void) {
        let closureNotification = ClosureNotification(self, notificationName: UITextView.textDidEndEditingNotification, closure: closure)
        objc_setAssociatedObject(self, &handleUITextViewDidEndEditingNotification, closureNotification, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func textDidEndEditing<Value>(_ keyPath: KeyPath<Self, Value>,
                                  closure: @escaping (Value) -> Void) {
        let closureNotification = ClosureNotificationKeyPath(self, keyPath: keyPath, notificationName: UITextView.textDidEndEditingNotification, closure: closure)
        objc_setAssociatedObject(self, &handleUITextViewDidEndEditingNotification, closureNotification, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func textDidBeginEditing(_ closure: @escaping (Self) -> Void) {
        let closureNotification = ClosureNotification(self, notificationName: UITextView.textDidBeginEditingNotification, closure: closure)
        objc_setAssociatedObject(self, &handleUITextViewDidBeginEditingNotification, closureNotification, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func textDidBeginEditing<Value>(_ keyPath: KeyPath<Self, Value>,
                                    closure: @escaping (Value) -> Void) {
        let closureNotification = ClosureNotificationKeyPath(self, keyPath: keyPath, notificationName: UITextView.textDidBeginEditingNotification, closure: closure)
        objc_setAssociatedObject(self, &handleUITextViewDidBeginEditingNotification, closureNotification, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
