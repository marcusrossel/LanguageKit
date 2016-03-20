//
//  LKVocableStyleType.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 20.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//



// MARK: - LKVocableStyleType

public protocol LKVocableStyleType: Hashable {
    var description: String { get }
}

// MARK: - Protocol Conformances

public extension LKVocableStyleType {
    /// Custom implemention of this property should be avoided, as it might cause disproportionate hash collisions
    public var hashValue: Int {
        return description.hashValue
    }
}

// MARK: - Operator

/// `LKVocableStyleType`'s with the same `description` should have the same purpose, and are therefore considered equal
@warn_unused_result
public func ==<T: LKVocableStyleType>(left: T, right: T) -> Bool {
    return left.description == right.description
}



// MARK: - LKAnyVocableStyle

/// Type-erasing wrapper for `LKVocableStyleType`
public struct LKAnyVocableStyle: LKVocableStyleType {
    public private(set) var description: String

    /// A custom implementation of `hashValue` is used to reduce potential hash collisions with other types (as this type is only a wrapper)
    public var hashValue: Int {
        return "LKAnyVocableStyle - \(description)".hashValue
    }

    public init<T: LKVocableStyleType>(_ vocableStyle: T) {
        description = vocableStyle.description
    }
}



// MARK: - LKVocableStyle

/// Simple structure conforming to the base requirements of `LKVocableStyleType`
///
/// All properties are implemented as constants, as this type is meant to be used like a pure value
public struct LKVocableStyle: LKVocableStyleType {
    public let description: String
}