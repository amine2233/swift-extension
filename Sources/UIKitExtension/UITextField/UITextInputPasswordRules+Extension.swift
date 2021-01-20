//
//  UITextInputPasswordRules+Extension.swift
//  ApplicationDelegate
//
//  Created by Amine Bensalah on 14/07/2019.
//

import UIKit

public enum PasswordRule {
    public enum CharacterClass {
        case upper, lower, digits, special, asciiPrintable, unicode
        case custom(Set<Character>)
    }

    case required(CharacterClass)
    case allowed(CharacterClass)
    case maxConsecutive(UInt)
    case minLength(UInt)
    case maxLength(UInt)
}

extension PasswordRule: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .required(characterClass):
            return "required: \(characterClass)"
        case let .allowed(characterClass):
            return "allowed: \(characterClass)"
        case let .maxConsecutive(length):
            return "max-consecutive: \(length)"
        case let .minLength(length):
            return "minlength: \(length)"
        case let .maxLength(length):
            return "maxlength: \(length)"
        }
    }
}

extension PasswordRule.CharacterClass: CustomStringConvertible {
    public var description: String {
        switch self {
        case .upper: return "upper"
        case .lower: return "lower"
        case .digits: return "digits"
        case .special: return "special"
        case .asciiPrintable: return "ascii-printable"
        case .unicode: return "unicode"
        case let .custom(characters):
            return "[" + String(characters) + "]"
        }
    }
}

@available(iOS 12.0, *)
extension UITextInputPasswordRules {
    public convenience init(rules: [PasswordRule]) {
        let descriptor = rules.map { $0.description }
            .joined(separator: "; ")

        self.init(descriptor: descriptor)
    }
}
