import Foundation

public extension NSRecursiveLock {
    convenience init(name: String?) {
        self.init()
        self.name = name
    }
}

public protocol Disposable {
    /// Dispose the signal observation or binding.
    func dispose()

    /// Returns `true` is already disposed.
    var isDisposed: Bool { get }
}

public struct NonDisposable: Disposable {
    public static let instance = NonDisposable()

    private init() {}

    public func dispose() {}

    public var isDisposed: Bool {
        false
    }
}

public final class SimpleDisposable: Disposable {
    public private(set) var isDisposed: Bool = false

    public func dispose() {
        isDisposed = true
    }

    public init(isDisposed: Bool = false) {
        self.isDisposed = isDisposed
    }
}

public final class BlockDisposable: Disposable {
    public var isDisposed: Bool {
        handler == nil
    }

    private var handler: (() -> Void)?
    private let lock = NSRecursiveLock(name: "com.recursiveLock.blockdisposable")

    public init(_ handler: @escaping (() -> Void)) {
        self.handler = handler
    }

    public func dispose() {
        lock.lock(); defer { lock.unlock() }
        if let handler = handler {
            self.handler = nil
            handler()
        }
    }
}

public final class DeinitDisposable: Disposable {
    public var otherDisposable: Disposable?

    public var isDisposed: Bool {
        otherDisposable == nil
    }

    public init(disposable: Disposable) {
        otherDisposable = disposable
    }

    public func dispose() {
        otherDisposable?.dispose()
    }

    deinit {
        dispose()
    }
}

public final class CompositeDisposable: Disposable {
    public private(set) var isDisposed: Bool = false
    private var disposables: [Disposable] = []
    private let lock = NSRecursiveLock(name: "com.recursiveLock.blockdisposable")

    public convenience init() {
        self.init([])
    }

    public init(_ disposables: [Disposable]) {
        self.disposables = disposables
    }

    public func add(disposable: Disposable) {
        lock.lock(); defer { lock.unlock() }
        if isDisposed {
            disposable.dispose()
        } else {
            disposables.append(disposable)
            disposables = disposables.filter { $0.isDisposed == false }
        }
    }

    public func add(completion: @escaping () -> Disposable) {
        add(disposable: completion())
    }

    public static func += (left: CompositeDisposable, right: Disposable) {
        left.add(disposable: right)
    }

    public func dispose() {
        lock.lock(); defer { lock.unlock() }
        isDisposed = true
        disposables.forEach { $0.dispose() }
        disposables.removeAll()
    }
}

extension Disposable {
    public func dispose(in disposeContainer: DisposeContainer) {
        disposeContainer.add(disposable: self)
    }
}

/// When bag gets deallocated, it will dispose all disposables it contains.
public protocol DisposableContainerProtocol: Disposable {
    func add(disposable: Disposable)
}

public final class DisposeContainer: DisposableContainerProtocol {
    private var disposables: [Disposable] = []
    private let lock = NSRecursiveLock(name: "com.recursiveLock.blockcontainerdisposable")

    public var isDisposed: Bool {
        disposables.isEmpty
    }

    public init() {}

    /// Add the given disposable to the bag.
    /// Disposable will be disposed when the bag is deallocated.
    public func add(disposable: Disposable) {
        disposables.append(disposable)
    }

    /// Add the given disposables to the bag.
    /// Disposables will be disposed when the bag is deallocated.
    public func add(disposables: [Disposable]) {
        disposables.forEach(add)
    }

    /// Add a disposable to a dispose bag.
    public static func += (left: DisposeContainer, right: Disposable) {
        left.add(disposable: right)
    }

    /// Add multiple disposables to a dispose bag.
    public static func += (left: DisposeContainer, right: [Disposable]) {
        left.add(disposables: right)
    }

    /// Disposes all disposables that are currenty in the bag.
    public func dispose() {
        disposables.forEach { $0.dispose() }
        disposables.removeAll()
    }

    deinit {
        dispose()
    }
}
