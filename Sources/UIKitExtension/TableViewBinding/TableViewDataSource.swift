//
//  TableViewDataSource.swift
//  Extensions
//
//  Created by Amine Bensalah on 28/05/2019.
//  Copyright © 2019 BENSALA. All rights reserved.
//

import UIKit

public protocol SectionProtocol {
    var header: String? { get }
    var footer: String? { get }
}

public protocol ArraySectionProtocol {
    associatedtype Section: SectionProtocol
    associatedtype Model

    var section: Section { get }
    var models: [Model] { get }
}

public class TableViewSectionDataSource<Section: ArraySectionProtocol>: NSObject, UITableViewDataSource {
    public typealias Configurator = ((Section.Model, IndexPath, UITableView) -> UITableViewCell)

    public private(set) var models: [Section]
    private let configurator: Configurator

    public init(models: [Section],
         configurator: @escaping Configurator) {
        self.models = models
        self.configurator = configurator
    }

    public func numberOfSections(in _: UITableView) -> Int {
        models.count
    }

    public func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        models[section].models.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        configurator(models[indexPath.section].models[indexPath.row], indexPath, tableView)
    }

    public func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        models[section].section.header
    }

    public func tableView(_: UITableView, titleForFooterInSection section: Int) -> String? {
        models[section].section.header
    }
}

public class TableViewDataSource<Model>: NSObject, UITableViewDataSource {
    public typealias Configurator = ((Model, IndexPath, UITableView) -> UITableViewCell)
    public typealias TitleConfigurator = ((Int, UITableView) -> String?)
    public typealias CanEditConfigurator = ((Model, IndexPath, UITableView) -> Bool)
    public typealias MoveRowConfigurator = ((Model, IndexPath, IndexPath, UITableView) -> Swift.Void)

    public private(set) var models: [Model]
    private let configurator: Configurator
    public var headerConfigurator: TitleConfigurator?
    public var footerConfigurator: TitleConfigurator?
    public var canEditRowAtConfigurator: CanEditConfigurator?
    public var canMovieRowAtConfigurator: CanEditConfigurator?
    public var moveRowConfigurator: MoveRowConfigurator?

    public init(models: [Model],
                configurator: @escaping Configurator) {
        self.models = models
        self.configurator = configurator
    }

    public func numberOfSections(in _: UITableView) -> Int {
        1
    }

    public func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        models.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        configurator(models[indexPath.row], indexPath, tableView)
    }

    public func tableView(_ tableView: UITableView,
                          titleForHeaderInSection section: Int) -> String? {
        headerConfigurator?(section, tableView)
    }

    public func tableView(_ tableView: UITableView,
                          titleForFooterInSection section: Int) -> String? {
        footerConfigurator?(section, tableView)
    }

    public func tableView(_ tableView: UITableView,
                          canEditRowAt indexPath: IndexPath) -> Bool {
        guard let completion = canEditRowAtConfigurator else { return false }
        return completion(models[indexPath.row], indexPath, tableView)
    }

    public func tableView(_ tableView: UITableView,
                          canMoveRowAt indexPath: IndexPath) -> Bool {
        guard let completion = canMovieRowAtConfigurator else { return false }
        return completion(models[indexPath.row], indexPath, tableView)
    }

    public func tableView(_ tableView: UITableView,
                          moveRowAt sourceIndexPath: IndexPath,
                          to destinationIndexPath: IndexPath) {
        moveRowConfigurator?(models[sourceIndexPath.row], sourceIndexPath, destinationIndexPath, tableView)
    }
}

private var handleBindTableView: Int = 0
private var handleBindTableViewSection: Int = 0

extension NSObjectProtocol where Self: UITableView {
    @discardableResult
    public func bind<Model>(_ models: [Model],
                            completion: @escaping ((Model, IndexPath, UITableView) -> UITableViewCell)) -> Self {
        let bindObject = TableViewDataSource(models: models, configurator: completion)
        objc_setAssociatedObject(self, &handleBindTableView, bindObject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        dataSource = bindObject
        return self
    }

    @discardableResult
    public func bindTitleHeader<Model>(_: [Model],
                                       completion: @escaping ((Int, UITableView) -> String?)) -> Self {
        let object = objc_getAssociatedObject(self, &handleBindTableView) as? TableViewDataSource<Model>
        object?.headerConfigurator = completion
        return self
    }

    @discardableResult
    public func bindTitleFooter<Model>(_: [Model],
                                       completion: @escaping ((Int, UITableView) -> String?)) -> Self {
        let object = objc_getAssociatedObject(self, &handleBindTableView) as? TableViewDataSource<Model>
        object?.footerConfigurator = completion
        return self
    }

    @discardableResult
    public func bindSection<Section: ArraySectionProtocol>(_ models: [Section],
                                                           completion: @escaping ((Section.Model, IndexPath, UITableView) -> UITableViewCell)) -> Self {
        let bindObject = TableViewSectionDataSource(models: models, configurator: completion)
        objc_setAssociatedObject(self, &handleBindTableViewSection, bindObject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        dataSource = bindObject
        return self
    }
}
