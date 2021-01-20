//
//  UITextField+DatePicker.swift
//  Extensions
//
//  Created by BENSALA on 24/05/2019.
//  Copyright © 2019 BENSALA. All rights reserved.
//

import UIKit

public extension UITextField {
    fileprivate var pickerAnimationDuration: TimeInterval {
        0.35
    }

    @discardableResult
    func resignFirstResponderPicker() -> Bool {
        NotificationCenter.default.post(name: UIResponder.pickerDidHideNotification, object: self, userInfo: [
            UIResponder.pickerAnimationDurationUserInfoKey: pickerAnimationDuration,
            UIResponder.pickerFrameBeginUserInfoKey: CGRect(x: 0, y: 0, width: 0, height: 260)
        ])

        return resignFirstResponder()
    }

    func becomeFirstResponderPicker() -> Bool {
        NotificationCenter.default.post(name: UIResponder.pickerWillShowNotification, object: self, userInfo: [
            UIResponder.pickerAnimationDurationUserInfoKey: pickerAnimationDuration,
            UIResponder.pickerFrameEndUserInfoKey: CGRect(x: 0, y: 0, width: 0, height: 260)
        ])
        return becomeFirstResponder()
    }

    func setInputViewDatePicker(date: Date, target: Any, selector: Selector) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        datePicker.date = date
        inputView = datePicker

        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        inputAccessoryView = toolBar
    }

    func setInputViewTimerPicker(timer: TimeInterval, target: Any, selector: Selector) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .countDownTimer
        datePicker.countDownDuration = timer
        inputView = datePicker

        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        inputAccessoryView = toolBar
    }

    @objc
    private func tapCancel() {
        resignFirstResponderPicker()
    }
}

private var handleDatePicker: Int = 0
private var handleTimerPicker: Int = 0

public class ClosureSelectorTarget<U> {
    public let selector: Selector
    private let target: U
    private let completion: (U) -> Swift.Void

    public init(bind target: U, completion: @escaping (U) -> Swift.Void) {
        selector = #selector(target(_:))
        self.target = target
        self.completion = completion
    }

    @objc
    public func target(_: AnyObject) {
        completion(target)
    }
}

public extension NSObjectProtocol where Self: UITextField {
    /// self.myTextField.inputView as? UIDatePicker
    @discardableResult
    func addTargetInputViewDatePicker(date: Date = Date(), closure: @escaping (Self) -> Void) -> Self {
        let closureSelector = ClosureSelectorTarget<Self>(bind: self, completion: closure)
        objc_setAssociatedObject(self, &handleDatePicker, closureSelector, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        setInputViewDatePicker(date: date, target: closureSelector, selector: closureSelector.selector)
        return self
    }

    /// self.myTextField.inputView as? UIDatePicker
    @discardableResult
    func addTargetInputViewTimerPicker(timer: TimeInterval = 0.0, closure: @escaping (Self) -> Void) -> Self {
        let closureSelector = ClosureSelectorTarget<Self>(bind: self, completion: closure)
        objc_setAssociatedObject(self, &handleDatePicker, closureSelector, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        setInputViewTimerPicker(timer: timer, target: closureSelector, selector: closureSelector.selector)
        return self
    }
}
