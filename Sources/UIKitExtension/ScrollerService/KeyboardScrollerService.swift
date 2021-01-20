//
//  KeyBoardScrollerService.swift
//  wifi-connect
//
//  Created by Amine Bensalah on 24/07/2018.
//  Copyright © 2018 Amine Bensalah. All rights reserved.
//

import UIKit

public class KeyboardScrollerService {
    public private(set) var scroller: UIScrollView
    private var isShowKeyboard = false

    public init(with scroller: UIScrollView) {
        self.scroller = scroller
        addObserver()
    }

    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: self)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: self)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, !isShowKeyboard else {
            return
        }

        self.isShowKeyboard = !self.isShowKeyboard

        let contentInset = scroller.contentInset
        scroller.contentInset.bottom += keyboardFrame.size.height
        scroller.scrollIndicatorInsets = contentInset

        if let animationDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]) as? TimeInterval {
            UIView.animate(withDuration: animationDuration) {
                self.scroller.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardDidHide(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue, isShowKeyboard else {
            return
        }

        self.isShowKeyboard = !self.isShowKeyboard

        var contentInset = scroller.contentInset
        contentInset.bottom -= keyboardFrame.size.height
        scroller.contentInset = contentInset
        scroller.scrollIndicatorInsets = contentInset

        if let animationDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]) as? TimeInterval {
            UIView.animate(withDuration: animationDuration) {
                self.scroller.layoutIfNeeded()
            }
        }
    }

    deinit {
        self.removeObserver()
    }
}
