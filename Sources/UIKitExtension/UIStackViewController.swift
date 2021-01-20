//
//  StackViewController.swift
//  Extensions
//
//  Created by Amine Bensalah on 24/05/2019.
//  Copyright © 2019 BENSALA. All rights reserved.
//

import UIKit

public protocol MasterScrollableViewController: UIViewController {
    func reload()
}

public protocol DetailScrollableViewController: UIViewController {
    var height: CGFloat { get }
    var delegate: MasterScrollableViewController? { get set }
}

open class UIStackViewController: UIViewController, MasterScrollableViewController {
    public let scrollView = UIScrollView()
    public let stackView = UIStackView()
    private var keyboardScrollerService: KeyboardScrollerService
    private var pickerScrollerService: PickerScrollerService

    public init() {
        keyboardScrollerService = KeyboardScrollerService(with: scrollView)
        pickerScrollerService = PickerScrollerService(with: scrollView)
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder _: NSCoder) {
        fatalError("Can't implement this method")
    }

    open override func loadView() {
        super.loadView()

        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        setupConstraints()
        stackView.axis = .vertical
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)
        ])
    }

    public func reload() {
        UIView.animate(withDuration: 0.2) {
            self.stackView.layoutIfNeeded()
        }
    }
}

public extension UIStackViewController {
    func add(_ child: DetailScrollableViewController) {
        addChild(child)
        stackView.addArrangedSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove(_ child: DetailScrollableViewController) {
        guard child.parent != nil else {
            return
        }

        child.willMove(toParent: nil)
        stackView.removeArrangedSubview(child.view)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}
