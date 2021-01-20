//
//  UIHaptic.swift
//  ApplicationDelegate
//
//  Created by Amine Bensalah on 25/10/2019.
//  https://github.com/efremidze/Haptica

import UIKit
import FoundationExtension

extension UIControl.Event: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

public func == (lhs: UIControl.Event, rhs: UIControl.Event) -> Bool {
    lhs.rawValue == rhs.rawValue
}

public enum HapticFeedbackStyle: Int {
    case light, medium, heavy
}

@available(iOS 10.0, *)
extension HapticFeedbackStyle {
    var value: UIImpactFeedbackGenerator.FeedbackStyle {
        UIImpactFeedbackGenerator.FeedbackStyle(rawValue: rawValue)!
    }
}

public enum HapticFeedbackType: Int {
    case success, warning, error
}

@available(iOS 10.0, *)
extension HapticFeedbackType {
    var value: UINotificationFeedbackGenerator.FeedbackType {
        UINotificationFeedbackGenerator.FeedbackType(rawValue: rawValue)!
    }
}

public enum Haptic {
    case impact(HapticFeedbackStyle)
    case notification(HapticFeedbackType)
    case selection

    // trigger
    public func generate() {
        guard #available(iOS 10, *) else { return }

        switch self {
        case let .impact(style):
            let generator = UIImpactFeedbackGenerator(style: style.value)
            generator.prepare()
            generator.impactOccurred()
        case let .notification(type):
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type.value)
        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
}

private var hapticKey: Void?
private var eventKey: Void?
private var targetsKey: Void?

public protocol Hapticable: AnyObject {
    func trigger(_ sender: Any)
}

extension Hapticable where Self: UIControl {
    /// `isHaptic` - enables haptic feedback
    public var isHaptic: Bool {
        get {
            guard let actions = actions(forTarget: self, forControlEvent: hapticControlEvents ?? .touchDown) else { return false }
            return !actions.filter { $0 == #selector(trigger).description }.isEmpty
        }
        set {
            if newValue {
                addTarget(self, action: #selector(trigger), for: hapticControlEvents ?? .touchDown)
            } else {
                removeTarget(self, action: #selector(trigger), for: hapticControlEvents ?? .touchDown)
            }
        }
    }

    public var hapticControlEvents: UIControl.Event? {
        get { getAssociatedObject(&eventKey) }
        set { setAssociatedObject(&eventKey, newValue) }
    }

    /// `hapticType` - haptic feedback type
    public var hapticType: Haptic? {
        get { getAssociatedObject(&hapticKey) }
        set { setAssociatedObject(&hapticKey, newValue) }
    }

    private var hapticTargets: [UIControl.Event: HapticTarget] {
        get { getAssociatedObject(&targetsKey) ?? [:] }
        set { setAssociatedObject(&targetsKey, newValue) }
    }

    /// Add haptic feedback for control events
    public func addHaptic(_ haptic: Haptic, forControlEvents events: UIControl.Event) {
        let hapticTarget = HapticTarget(haptic: haptic)
        hapticTargets[events] = hapticTarget
        addTarget(hapticTarget, action: #selector(hapticTarget.trigger), for: events)
    }

    /// Remove haptic feedback for control events
    public func removeHaptic(forControlEvents events: UIControl.Event) {
        guard let hapticTarget = hapticTargets[events] else { return }
        hapticTargets[events] = nil
        removeTarget(hapticTarget, action: #selector(hapticTarget.trigger), for: events)
    }
}

extension UIControl: Hapticable {
    @objc public func trigger(_: Any) {
        hapticType?.generate()
    }
}

private class HapticTarget {
    let haptic: Haptic
    init(haptic: Haptic) {
        self.haptic = haptic
    }

    @objc func trigger(_: Any) {
        haptic.generate()
    }
}
