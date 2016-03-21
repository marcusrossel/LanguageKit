//
//  LKLanguageType.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 20.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//



// MARK: - LKLanguageType

public protocol LKLanguageType: Hashable {
    var description: String { get }
}

// MARK: - Protocol Conformances

public extension LKLanguageType {
    /// Custom implemention of this property should be avoided, as it might
    /// cause disproportionate hash collisions
    public var hashValue: Int {
        return description.hashValue
    }
}

// MARK: - Operator

/// `LKLanguageTypes`s with the same `description` should have the same purpose,
/// and are therefore considered equal
@warn_unused_result
public func ==<T: LKLanguageType>(left: T, right: T) -> Bool {
    return left.description == right.description
}



// MARK: - LKAnyLanguage

/// Type-erasing wrapper for `LKLanguageType`
public struct LKAnyLanguage: LKLanguageType {
    public private(set) var description: String

    /// A custom implementation of `hashValue` is used to reduce potential
    /// hash collisions with other types (as this type is only a wrapper)
    public var hashValue: Int {
        return "LKAnyLanguage - \(description)".hashValue
    }

    public init<T: LKLanguageType>(_ language: T) {
        description = language.description
    }
}



// MARK: - LKLanguage

/// Simple structure conforming to the base requirements of `LKLanguageType`
///
/// All properties are implemented as constants, as this type is meant to be
/// used like a pure value
public struct LKLanguage: LKLanguageType {
    public let description: String
}
