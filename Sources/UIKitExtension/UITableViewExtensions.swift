//
//  UITableViewExtensions.swift
//  Extensions
//
//  Created by BENSALA on 25/04/2019.
//  Copyright © 2019 BENSALA. All rights reserved.
//

import UIKit

public extension UITableView {
    func register<T: UITableViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellReuseIdentifier: "\(T.self)")
    }

    func register<T: UITableViewCell>(_ cellClasses: [T.Type]) {
        cellClasses.forEach { register($0) }
    }

    func dequeueReusableCell<T: UITableViewCell>(withType _: T.Type) -> T? {
        dequeueReusableCell(withIdentifier: "\(T.self)") as? T
    }

    func dequeueReusableCell<T: UITableViewCell>(withType _: T.Type, for indexPath: IndexPath) -> T? {
        dequeueReusableCell(withIdentifier: "\(T.self)", for: indexPath) as? T
    }

    func register<T: UITableViewHeaderFooterView>(_ viewHeaderFooterClass: T.Type) {
        register(viewHeaderFooterClass, forHeaderFooterViewReuseIdentifier: "\(T.self)")
    }

    func register<T: UITableViewHeaderFooterView>(_ viewHeaderFooterClasses: [T.Type]) {
        viewHeaderFooterClasses.forEach { register($0) }
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(withType _: T.Type) -> T? {
        dequeueReusableHeaderFooterView(withIdentifier: "\(T.self)") as? T
    }
}

public class TableViewDidSelectDelegateManager: NSObject, UITableViewDelegate {
    public var closureDidSelectRowAt: ((IndexPath) -> Void)?
    public var closureDidDeselectRowAt: ((IndexPath) -> Void)?

    public var closureWillSelectRowAt: ((IndexPath) -> IndexPath?)?
    public var closureWillDeselectRowAt: ((IndexPath) -> IndexPath?)?

    public var closureWillDisplayCellAtIndexPath: ((UITableViewCell, IndexPath) -> Void)?
    public var closureWillDisplayHeaderViewAtIndexPath: ((UIView, Int) -> Void)?
    public var closureWillDisplayFooterViewAtIndexPath: ((UIView, Int) -> Void)?
    public var closureHeightForRowAt: ((IndexPath) -> CGFloat)?
    public var closureHeightForHeaderInSection: ((Int) -> CGFloat)?
    public var closureHeightForFooterInSection: ((Int) -> CGFloat)?

    public var closureEstimateHeightForRowAt: ((IndexPath) -> CGFloat)?
    public var closureEstimateHeightForHeaderInSection: ((Int) -> CGFloat)?
    public var closureEstimateHeightForFooterInSection: ((Int) -> CGFloat)?

    public var closureViewForHeaderInSection: ((Int) -> UIView?)?
    public var closureViewForFooterInSection: ((Int) -> UIView?)?

    public var closureAccessoryButtonTappedForRowWith: ((IndexPath) -> Void)?
    public var closureShouldHighlightRowAt: ((IndexPath) -> Bool)?

    public var closureDidHighlightRowAt: ((IndexPath) -> Void)?
    public var closureDidUnhighlightRowAt: ((IndexPath) -> Void)?

    public var closureDidEndDisplaying: ((UITableViewCell, IndexPath) -> Void)?
    public var closureDidEndDisplayingHeaderView: ((UIView, Int) -> Void)?
    public var closureDidEndDisplayingFooterView: ((UIView, Int) -> Void)?

    public let tableView: UITableView

    public init(_ tableView: UITableView) {
        self.tableView = tableView
        super.init()
        self.tableView.delegate = self
    }

    public func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        closureDidSelectRowAt?(indexPath)
    }

    public func tableView(_: UITableView, didDeselectRowAt indexPath: IndexPath) {
        closureDidDeselectRowAt?(indexPath)
    }

    public func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        closureWillDisplayCellAtIndexPath?(cell, indexPath)
    }

    public func tableView(_: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        closureWillDisplayHeaderViewAtIndexPath?(view, section)
    }

    public func tableView(_: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        closureWillDisplayFooterViewAtIndexPath?(view, section)
    }

    public func tableView(_: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        closureDidEndDisplaying?(cell, indexPath)
    }

    public func tableView(_: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        closureDidEndDisplayingHeaderView?(view, section)
    }

    public func tableView(_: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        closureDidEndDisplayingFooterView?(view, section)
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        closureHeightForRowAt?(indexPath) ?? tableView.rowHeight
    }

    public func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        closureHeightForHeaderInSection?(section) ?? 0.0
    }

    public func tableView(_: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        closureHeightForFooterInSection?(section) ?? 0.0
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        closureEstimateHeightForRowAt?(indexPath) ?? tableView.estimatedRowHeight
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        closureEstimateHeightForHeaderInSection?(section) ?? tableView.estimatedSectionHeaderHeight
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        closureEstimateHeightForFooterInSection?(section) ?? tableView.estimatedSectionFooterHeight
    }

    public func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        closureViewForHeaderInSection?(section)
    }

    public func tableView(_: UITableView, viewForFooterInSection section: Int) -> UIView? {
        closureViewForFooterInSection?(section)
    }

    public func tableView(_: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        closureAccessoryButtonTappedForRowWith?(indexPath)
    }

    public func tableView(_: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        closureShouldHighlightRowAt?(indexPath) ?? true
    }

    public func tableView(_: UITableView, didHighlightRowAt indexPath: IndexPath) {
        closureDidHighlightRowAt?(indexPath)
    }

    public func tableView(_: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        closureDidUnhighlightRowAt?(indexPath)
    }

    public func tableView(_: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        closureWillSelectRowAt?(indexPath)
    }

    public func tableView(_: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        closureWillDeselectRowAt?(indexPath)
    }
}

public extension UITableView {
    private struct AssociatedKeys {
        static var DelegateManager = "DelegateManager"
    }

    private var delegateManager: TableViewDidSelectDelegateManager {
        if let delegateManager = objc_getAssociatedObject(self, &UITableView.AssociatedKeys.DelegateManager) {
            return delegateManager as! TableViewDidSelectDelegateManager
        } else {
            let delegateManager = TableViewDidSelectDelegateManager(self)
            objc_setAssociatedObject(
                self,
                &UITableView.AssociatedKeys.DelegateManager,
                delegateManager,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            return delegateManager
        }
    }

    func didSelectRow(_ closure: @escaping ((IndexPath) -> Void)) {
        delegateManager.closureDidSelectRowAt = closure
    }

    func didDeselectRow(_ closure: @escaping ((IndexPath) -> Void)) {
        delegateManager.closureDidDeselectRowAt = closure
    }
}

public class TableViewDataSourceManagerCollection<T: Collection>: NSObject, UITableViewDataSource {
    public let closure: (T, IndexPath) -> UITableViewCell
    public let collection: T

    public init(_ collection: T, closure: @escaping ((T, IndexPath) -> UITableViewCell)) {
        self.collection = collection
        self.closure = closure
    }

    public func numberOfSections(in _: UITableView) -> Int {
        1
    }

    public func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        collection.count
    }

    public func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        closure(collection, indexPath)
    }
}

public extension UITableView {
    func reloadData(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
}
