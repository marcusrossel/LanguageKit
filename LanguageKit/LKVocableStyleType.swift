//
//  LKVocableStyleType.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 20.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

import Foundation

/// A protocol for types, which are able to represent vocable styles.
public protocol LKVocableStyleType: Hashable {
    var qualifier: String { get }
}

public extension LKVocableStyleType {
    /// Custom implemention of this property should be avoided, as it might
    /// cause disproportionate hash collisions.
    public var hashValue: Int { return qualifier.hashValue }
}

/// `LKVocableStyleType`'s with the same `qualifier` should have the same
/// purpose, and are therefore considered equal.
@warn_unused_result
public func ==<T: LKVocableStyleType>(lhs: T, rhs: T) -> Bool {
    return lhs.qualifier == rhs.qualifier
}