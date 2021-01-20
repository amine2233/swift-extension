//
//  PickerScrollerService.swift
//  Extensions
//
//  Created by Amine Bensalah on 25/05/2019.
//  Copyright © 2019 BENSALA. All rights reserved.
//

import UIKit

public extension UIResponder {
    static let pickerWillShowNotification = NSNotification.Name(rawValue: "PickerWillShowNotification")
    static let pickerDidHideNotification = NSNotification.Name(rawValue: "PickerDidHideNotification")

    static let pickerFrameEndUserInfoKey = "pickerFrameEndUserInfoKey"
    static let pickerFrameBeginUserInfoKey = "pickerFrameBeginUserInfoKey"
    static let pickerAnimationDurationUserInfoKey = "pickerAnimationDurationUserInfoKey"
}

public class PickerScrollerService {
    public var scroller: UIScrollView
    private var isShowKeyboard = false

    public init(with scroller: UIScrollView) {
        self.scroller = scroller
        addObserver()
    }

    public func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.pickerWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.pickerDidHideNotification, object: nil)
    }

    public func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.pickerWillShowNotification, object: self)
        NotificationCenter.default.removeObserver(self, name: UIResponder.pickerDidHideNotification, object: self)
    }

    @objc
    private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.pickerFrameEndUserInfoKey] as? NSValue)?.cgRectValue, !isShowKeyboard else {
            return
        }

        self.isShowKeyboard = !self.isShowKeyboard

        let contentInset = scroller.contentInset
        scroller.contentInset.bottom += keyboardFrame.size.height
        scroller.scrollIndicatorInsets = contentInset

        if let animationDuration = (notification.userInfo?[UIResponder.pickerAnimationDurationUserInfoKey]) as? TimeInterval {
            UIView.animate(withDuration: animationDuration) {
                self.scroller.layoutIfNeeded()
            }
        }
    }

    @objc
    private func keyboardDidHide(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.pickerFrameBeginUserInfoKey] as? NSValue)?.cgRectValue, isShowKeyboard else {
            return
        }

        self.isShowKeyboard = !self.isShowKeyboard

        var contentInset = scroller.contentInset
        contentInset.bottom -= keyboardFrame.size.height
        scroller.contentInset = contentInset
        scroller.scrollIndicatorInsets = contentInset

        if let animationDuration = (notification.userInfo?[UIResponder.pickerAnimationDurationUserInfoKey]) as? TimeInterval {
            UIView.animate(withDuration: animationDuration) {
                self.scroller.layoutIfNeeded()
            }
        }
    }

    deinit {
        self.removeObserver()
    }
}
