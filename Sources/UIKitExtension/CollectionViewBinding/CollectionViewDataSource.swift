//
//  CollectionViewDataSource.swift
//  Extensions
//
//  Created by Amine Bensalah on 06/06/2019.
//  Copyright © 2019 BENSALA. All rights reserved.
//

import UIKit

public class CollectionViewDataSource<Model>: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    public typealias Configurator = ((Model, IndexPath, UICollectionView) -> UICollectionViewCell)
    public typealias ViewForSupplementaryElement = ((Model, String, IndexPath, UICollectionView) -> UICollectionReusableView)
    public typealias CanEditConfigurator = ((Model, IndexPath, UICollectionView) -> Bool)
    public typealias MoveRowConfigurator = ((Model, IndexPath, IndexPath, UICollectionView) -> Swift.Void)

    public typealias SelectorConfigurator = ((Model, IndexPath, UICollectionView) -> Void)

    public var models: [Model]
    public var configurator: Configurator?
    public var viewForSupplementaryElement: ViewForSupplementaryElement?
    public var canMovieRowAtConfigurator: CanEditConfigurator?
    public var moveRowConfigurator: MoveRowConfigurator?
    public var didSelect: SelectorConfigurator?
    public var didDeselect: SelectorConfigurator?

    public init(models: [Model]) {
        self.models = models
    }

    public func numberOfSections(in _: UICollectionView) -> Int {
        1
    }

    public func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        models.count
    }

    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        configurator?(models[indexPath.row], indexPath, collectionView) ?? UICollectionViewCell()
    }

    public func collectionView(_ collectionView: UICollectionView,
                               viewForSupplementaryElementOfKind kind: String,
                               at indexPath: IndexPath) -> UICollectionReusableView {
        viewForSupplementaryElement?(models[indexPath.row], kind, indexPath, collectionView) ?? UICollectionReusableView(frame: .zero)
    }

    public func collectionView(_ collectionView: UICollectionView,
                               canMoveItemAt indexPath: IndexPath) -> Bool {
        canMovieRowAtConfigurator?(models[indexPath.row], indexPath, collectionView) ?? false
    }

    public func collectionView(_ collectionView: UICollectionView,
                               moveItemAt sourceIndexPath: IndexPath,
                               to destinationIndexPath: IndexPath) {
        moveRowConfigurator?(models[sourceIndexPath.row], sourceIndexPath, destinationIndexPath, collectionView)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelect?(models[indexPath.row], indexPath, collectionView)
    }

    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        didDeselect?(models[indexPath.row], indexPath, collectionView)
    }
}

extension UICollectionView {
    private struct AssociatedKeys {
        static var DataSourceManager = "DataSourceManager"
    }

    private func get<Model>(_ models: [Model]) -> CollectionViewDataSource<Model> {
        if let bindObjc = objc_getAssociatedObject(self, &UICollectionView.AssociatedKeys.DataSourceManager) as? CollectionViewDataSource<Model> {
            return bindObjc
        } else {
            let bindObjc = CollectionViewDataSource(models: models)
            dataSource = bindObjc
            objc_setAssociatedObject(
                self,
                &UICollectionView.AssociatedKeys.DataSourceManager,
                bindObjc,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            return bindObjc
        }
    }

    @discardableResult
    public func bind<Model>(_ models: [Model],
                            completion: @escaping ((Model, IndexPath, UICollectionView) -> UICollectionViewCell)) -> Self {
        let bindObject = get(models)
        bindObject.configurator = completion
        return self
    }

    @discardableResult
    public func bindViewForSupplementaryElement<Model>(_ models: [Model],
                                                       completion: @escaping ((Model, String, IndexPath, UICollectionView) -> UICollectionReusableView)) -> Self {
        let bindObject = get(models)
        bindObject.viewForSupplementaryElement = completion
        return self
    }

    @discardableResult
    public func bindDidSelect<Model>(_ models: [Model],
                                     completion: @escaping ((Model, IndexPath, UICollectionView) -> Void)) -> Self {
        let bindObject = get(models)
        bindObject.didSelect = completion
        return self
    }

    @discardableResult
    public func bindDidDeselect<Model>(_ models: [Model],
                                       completion: @escaping ((Model, IndexPath, UICollectionView) -> Void)) -> Self {
        let bindObject = get(models)
        bindObject.didDeselect = completion
        return self
    }
}
