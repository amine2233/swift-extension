//
//  Combine.swift
//  Extensions
//
//  Created by Amine Bensalah on 28/05/2019.
//  Copyright © 2019 BENSALA. All rights reserved.
//

import Foundation

public extension NSObjectProtocol where Self: NSObject {
    func combine<Arg1, Arg2>(_ sourceKeyPathArg1: KeyPath<Self, Arg1>, _ sourceKeyPathArg2: KeyPath<Self, Arg2>, completion: @escaping (Arg1, Arg2) -> Swift.Void) -> Disposable {
        let dispose1 = observe(sourceKeyPathArg1) { [unowned self] in completion($0, self.keyPathSelf[keyPath: sourceKeyPathArg2]) }
        let dispose2 = observe(sourceKeyPathArg2) { [unowned self] in completion(self.keyPathSelf[keyPath: sourceKeyPathArg1], $0) }
        return CompositeDisposable([dispose1, dispose2])
    }
    
    func combine<Arg1, Arg2, Arg3>(_ sourceKeyPathArg1: KeyPath<Self, Arg1>, _ sourceKeyPathArg2: KeyPath<Self, Arg2>, _ sourceKeyPathArg3: KeyPath<Self, Arg3>, completion: @escaping (Arg1, Arg2, Arg3) -> Swift.Void) -> Disposable {
        let dispose1 = observe(sourceKeyPathArg1) { [unowned self] in completion($0, self.keyPathSelf[keyPath: sourceKeyPathArg2], self.keyPathSelf[keyPath: sourceKeyPathArg3]) }
        let dispose2 = observe(sourceKeyPathArg2) { [unowned self] in completion(self.keyPathSelf[keyPath: sourceKeyPathArg1], $0, self.keyPathSelf[keyPath: sourceKeyPathArg3]) }
        let dispose3 = observe(sourceKeyPathArg3) { [unowned self] in completion(self.keyPathSelf[keyPath: sourceKeyPathArg1], self.keyPathSelf[keyPath: sourceKeyPathArg2], $0) }
        return CompositeDisposable([dispose1, dispose2, dispose3])
    }
    
    func combine<Arg1, Arg2, Arg3, Arg4>(_ sourceKeyPathArg1: KeyPath<Self, Arg1>, _ sourceKeyPathArg2: KeyPath<Self, Arg2>, _ sourceKeyPathArg3: KeyPath<Self, Arg3>, _ sourceKeyPathArg4: KeyPath<Self, Arg4>, completion: @escaping (Arg1, Arg2, Arg3, Arg4) -> Swift.Void) -> Disposable {
        let dispose1 = observe(sourceKeyPathArg1) { [unowned self] in completion($0, self.keyPathSelf[keyPath: sourceKeyPathArg2], self.keyPathSelf[keyPath: sourceKeyPathArg3], self.keyPathSelf[keyPath: sourceKeyPathArg4]) }
        let dispose2 = observe(sourceKeyPathArg2) { [unowned self] in completion(self.keyPathSelf[keyPath: sourceKeyPathArg1], $0, self.keyPathSelf[keyPath: sourceKeyPathArg3], self.keyPathSelf[keyPath: sourceKeyPathArg4]) }
        let dispose3 = observe(sourceKeyPathArg3) { [unowned self] in completion(self.keyPathSelf[keyPath: sourceKeyPathArg1], self.keyPathSelf[keyPath: sourceKeyPathArg2], $0, self.keyPathSelf[keyPath: sourceKeyPathArg4]) }
        let dispose4 = observe(sourceKeyPathArg4) { [unowned self] in completion(self.keyPathSelf[keyPath: sourceKeyPathArg1], self.keyPathSelf[keyPath: sourceKeyPathArg2], self.keyPathSelf[keyPath: sourceKeyPathArg3], $0) }
        return CompositeDisposable([dispose1, dispose2, dispose3, dispose4])
    }
    
    func combine<Arg1, Arg2, Value>(_ sourceKeyPathArg1: KeyPath<Self, Arg1>, _ sourceKeyPathArg2: KeyPath<Self, Arg2>, result resultKeyPath: ReferenceWritableKeyPath<Self, Value>, completion: @escaping (Arg1, Arg2) -> Value) -> Disposable {
        let dispose1 = observe(sourceKeyPathArg1) { [unowned self] in self.keyPathSelf[keyPath: resultKeyPath] = completion($0, self.keyPathSelf[keyPath: sourceKeyPathArg2]) }
        let dispose2 = observe(sourceKeyPathArg2) { [unowned self] in self.keyPathSelf[keyPath: resultKeyPath] = completion(self.keyPathSelf[keyPath: sourceKeyPathArg1], $0) }
        return CompositeDisposable([dispose1, dispose2])
    }
    
    func combine<Arg1, Arg2, Arg3, Value>(_ sourceKeyPathArg1: KeyPath<Self, Arg1>, _ sourceKeyPathArg2: KeyPath<Self, Arg2>, _ sourceKeyPathArg3: KeyPath<Self, Arg3>, result sourceKeyPathValue: ReferenceWritableKeyPath<Self, Value>, completion: @escaping (Arg1, Arg2, Arg3) -> Value) -> Disposable {
        let dispose1 = observe(sourceKeyPathArg1) { [unowned self] in self.keyPathSelf[keyPath: sourceKeyPathValue] = completion($0, self.keyPathSelf[keyPath: sourceKeyPathArg2], self.keyPathSelf[keyPath: sourceKeyPathArg3]) }
        let dispose2 = observe(sourceKeyPathArg2) { [unowned self] in self.keyPathSelf[keyPath: sourceKeyPathValue] = completion(self.keyPathSelf[keyPath: sourceKeyPathArg1], $0, self.keyPathSelf[keyPath: sourceKeyPathArg3]) }
        let dispose3 = observe(sourceKeyPathArg3) { [unowned self] in self.keyPathSelf[keyPath: sourceKeyPathValue] = completion(self.keyPathSelf[keyPath: sourceKeyPathArg1], self.keyPathSelf[keyPath: sourceKeyPathArg2], $0) }
        return CompositeDisposable([dispose1, dispose2, dispose3])
    }
    
    // swiftlint:disable function_parameter_count
    func combine<Arg1, Arg2, Arg3, Arg4, Value>(_ sourceKeyPathArg1: KeyPath<Self, Arg1>,
                                                _ sourceKeyPathArg2: KeyPath<Self, Arg2>,
                                                _ sourceKeyPathArg3: KeyPath<Self, Arg3>,
                                                _ sourceKeyPathArg4: KeyPath<Self, Arg4>,
                                                result sourceKeyPathValue: ReferenceWritableKeyPath<Self, Value>,
                                                completion: @escaping (Arg1, Arg2, Arg3, Arg4) -> Value) -> Disposable {
        let dispose1 = observe(sourceKeyPathArg1) { [weak self] in
            guard let self = self else { return }
            self.keyPathSelf[keyPath: sourceKeyPathValue] = completion($0, self.keyPathSelf[keyPath: sourceKeyPathArg2], self.keyPathSelf[keyPath: sourceKeyPathArg3], self.keyPathSelf[keyPath: sourceKeyPathArg4])
        }
        let dispose2 = observe(sourceKeyPathArg2) { [weak self] in
            guard let self = self else { return }
            self.keyPathSelf[keyPath: sourceKeyPathValue] = completion(self.keyPathSelf[keyPath: sourceKeyPathArg1], $0, self.keyPathSelf[keyPath: sourceKeyPathArg3], self.keyPathSelf[keyPath: sourceKeyPathArg4])
        }
        let dispose3 = observe(sourceKeyPathArg3) { [weak self] in
            guard let self = self else { return }
            self.keyPathSelf[keyPath: sourceKeyPathValue] = completion(self.keyPathSelf[keyPath: sourceKeyPathArg1], self.keyPathSelf[keyPath: sourceKeyPathArg2], $0, self.keyPathSelf[keyPath: sourceKeyPathArg4])
        }
        let dispose4 = observe(sourceKeyPathArg4) { [weak self] in
            guard let self = self else { return }
            self.keyPathSelf[keyPath: sourceKeyPathValue] = completion(self.keyPathSelf[keyPath: sourceKeyPathArg1], self.keyPathSelf[keyPath: sourceKeyPathArg2], self.keyPathSelf[keyPath: sourceKeyPathArg3], $0)
        }
        return CompositeDisposable([dispose1, dispose2, dispose3, dispose4])
    }
    
    // swiftlint:enable function_parameter_count
    
    func combine<Arg1, Arg2, Target: AnyObject, Value>(_ sourceKeyPathArg1: KeyPath<Self, Arg1>,
                                                       _ sourceKeyPathArg2: KeyPath<Self, Arg2>,
                                                       cible: Target,
                                                       cibleKeyPath: ReferenceWritableKeyPath<Target, Value>,
                                                       completion: @escaping (Arg1, Arg2) -> Value) -> Disposable {
        let dispose1 = observe(sourceKeyPathArg1) { [weak cible, weak self] in
            guard let strongCible = cible, let self = self else { return }
            strongCible[keyPath: cibleKeyPath] = completion($0, self.keyPathSelf[keyPath: sourceKeyPathArg2])
        }
        let dispose2 = observe(sourceKeyPathArg2) { [weak cible, weak self] in
            guard let strongCible = cible, let self = self else { return }
            strongCible[keyPath: cibleKeyPath] = completion(self.keyPathSelf[keyPath: sourceKeyPathArg1], $0)
        }
        return CompositeDisposable([dispose1, dispose2])
    }
    
    // swiftlint:enable function_parameter_count
    
    // swiftlint:disable function_parameter_count
    func combine<Arg1, Arg2, Arg3, Target: AnyObject, Value>(_ sourceKeyPathArg1: KeyPath<Self, Arg1>,
                                                             _ sourceKeyPathArg2: KeyPath<Self, Arg2>,
                                                             _ sourceKeyPathArg3: KeyPath<Self, Arg3>,
                                                             cible: Target,
                                                             cibleKeyPath: ReferenceWritableKeyPath<Target, Value>,
                                                             completion: @escaping (Arg1, Arg2, Arg3) -> Value) -> Disposable {
        let dispose1 = observe(sourceKeyPathArg1) { [weak cible, weak self] in
            guard let strongCible = cible, let self = self else { return }
            strongCible[keyPath: cibleKeyPath] = completion($0, self.keyPathSelf[keyPath: sourceKeyPathArg2], self.keyPathSelf[keyPath: sourceKeyPathArg3])
        }
        let dispose2 = observe(sourceKeyPathArg2) { [weak cible, weak self] in
            guard let strongCible = cible, let self = self else { return }
            strongCible[keyPath: cibleKeyPath] = completion(self.keyPathSelf[keyPath: sourceKeyPathArg1], $0, self.keyPathSelf[keyPath: sourceKeyPathArg3])
        }
        let dispose3 = observe(sourceKeyPathArg3) { [weak cible, weak self] in
            guard let strongCible = cible, let self = self else { return }
            strongCible[keyPath: cibleKeyPath] = completion(self.keyPathSelf[keyPath: sourceKeyPathArg1], self.keyPathSelf[keyPath: sourceKeyPathArg2], $0)
        }
        return CompositeDisposable([dispose1, dispose2, dispose3])
    }
    
    // swiftlint:enable function_parameter_count
    
    // swiftlint:disable function_parameter_count
    func combine<Arg1, Arg2, Arg3, Arg4, Target: AnyObject, Value>(_ sourceKeyPathArg1: KeyPath<Self, Arg1>,
                                                                   _ sourceKeyPathArg2: KeyPath<Self, Arg2>,
                                                                   _ sourceKeyPathArg3: KeyPath<Self, Arg3>,
                                                                   _ sourceKeyPathArg4: KeyPath<Self, Arg4>,
                                                                   cible: Target,
                                                                   cibleKeyPath: ReferenceWritableKeyPath<Target, Value>,
                                                                   completion: @escaping (Arg1, Arg2, Arg3, Arg4) -> Value) -> Disposable {
        let dispose1 = observe(sourceKeyPathArg1) { [weak cible, weak self] in
            guard let strongCible = cible, let self = self else { return }
            strongCible[keyPath: cibleKeyPath] = completion($0, self.keyPathSelf[keyPath: sourceKeyPathArg2], self.keyPathSelf[keyPath: sourceKeyPathArg3], self.keyPathSelf[keyPath: sourceKeyPathArg4])
        }
        let dispose2 = observe(sourceKeyPathArg2) { [weak cible, weak self] in
            guard let strongCible = cible, let self = self else { return }
            strongCible[keyPath: cibleKeyPath] = completion(self.keyPathSelf[keyPath: sourceKeyPathArg1], $0, self.keyPathSelf[keyPath: sourceKeyPathArg3], self.keyPathSelf[keyPath: sourceKeyPathArg4])
        }
        let dispose3 = observe(sourceKeyPathArg3) { [weak cible, weak self] in
            guard let strongCible = cible, let self = self else { return }
            strongCible[keyPath: cibleKeyPath] = completion(self.keyPathSelf[keyPath: sourceKeyPathArg1], self.keyPathSelf[keyPath: sourceKeyPathArg2], $0, self.keyPathSelf[keyPath: sourceKeyPathArg4])
        }
        let dispose4 = observe(sourceKeyPathArg4) { [weak cible, weak self] in
            guard let strongCible = cible, let self = self else { return }
            strongCible[keyPath: cibleKeyPath] = completion(self.keyPathSelf[keyPath: sourceKeyPathArg1], self.keyPathSelf[keyPath: sourceKeyPathArg2], self.keyPathSelf[keyPath: sourceKeyPathArg3], $0)
        }
        return CompositeDisposable([dispose1, dispose2, dispose3, dispose4])
    }
    
    // swiftlint:enable function_parameter_count
    
    // swiftlint:disable function_parameter_count
    func combine<Arg1, Arg2, Arg3, Arg4, Arg5, Target: AnyObject, Value>(_ sourceKeyPathArg1: KeyPath<Self, Arg1>,
                                                                         _ sourceKeyPathArg2: KeyPath<Self, Arg2>,
                                                                         _ sourceKeyPathArg3: KeyPath<Self, Arg3>,
                                                                         _ sourceKeyPathArg4: KeyPath<Self, Arg4>,
                                                                         _ sourceKeyPathArg5: KeyPath<Self, Arg5>,
                                                                         cible: Target,
                                                                         cibleKeyPath: ReferenceWritableKeyPath<Target, Value>,
                                                                         completion: @escaping (Arg1, Arg2, Arg3, Arg4, Arg5) -> Value) -> Disposable {
        let dispose1 = observe(sourceKeyPathArg1) { [weak cible, weak self] in
            guard let strongCible = cible, let self = self else { return }
            strongCible[keyPath: cibleKeyPath] = completion($0, self.keyPathSelf[keyPath: sourceKeyPathArg2], self.keyPathSelf[keyPath: sourceKeyPathArg3], self.keyPathSelf[keyPath: sourceKeyPathArg4], self.keyPathSelf[keyPath: sourceKeyPathArg5])
        }
        let dispose2 = observe(sourceKeyPathArg2) { [weak cible, weak self] in
            guard let strongCible = cible, let self = self else { return }
            strongCible[keyPath: cibleKeyPath] = completion(self.keyPathSelf[keyPath: sourceKeyPathArg1], $0, self.keyPathSelf[keyPath: sourceKeyPathArg3], self.keyPathSelf[keyPath: sourceKeyPathArg4], self.keyPathSelf[keyPath: sourceKeyPathArg5])
        }
        let dispose3 = observe(sourceKeyPathArg3) { [weak cible, weak self] in
            guard let strongCible = cible, let self = self else { return }
            strongCible[keyPath: cibleKeyPath] = completion(self.keyPathSelf[keyPath: sourceKeyPathArg1], self.keyPathSelf[keyPath: sourceKeyPathArg2], $0, self.keyPathSelf[keyPath: sourceKeyPathArg4], self.keyPathSelf[keyPath: sourceKeyPathArg5])
        }
        let dispose4 = observe(sourceKeyPathArg4) { [weak cible, weak self] in
            guard let strongCible = cible, let self = self else { return }
            strongCible[keyPath: cibleKeyPath] = completion(self.keyPathSelf[keyPath: sourceKeyPathArg1], self.keyPathSelf[keyPath: sourceKeyPathArg2], self.keyPathSelf[keyPath: sourceKeyPathArg3], $0, self.keyPathSelf[keyPath: sourceKeyPathArg5])
        }
        let dispose5 = observe(sourceKeyPathArg5) { [weak cible, weak self] in
            guard let strongCible = cible, let self = self else { return }
            strongCible[keyPath: cibleKeyPath] = completion(self.keyPathSelf[keyPath: sourceKeyPathArg1], self.keyPathSelf[keyPath: sourceKeyPathArg2], self.keyPathSelf[keyPath: sourceKeyPathArg3], self.keyPathSelf[keyPath: sourceKeyPathArg4], $0)
        }
        
        return CompositeDisposable([dispose1, dispose2, dispose3, dispose4, dispose5])
    }
    
    // swiftlint:enable function_parameter_count
}
