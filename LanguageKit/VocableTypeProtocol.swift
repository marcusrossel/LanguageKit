//
//  VocableTypeProtocol.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 20.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

/// A protocol for types, which are able to represent vocable-types.
public protocol VocableTypeProtocol: Hashable {
    var qualifier: String { get }
}

public extension VocableTypeProtocol {
    /// Custom implemention of this property should be avoided, as it might
    /// cause disproportionate hash collisions.
    public var hashValue: Int { return qualifier.hashValue }
}

/// `VocableTypeProtocol`'s with the same `qualifier` should have the same
/// purpose, and are therefore considered equal.
@warn_unused_result
public func ==<T: VocableTypeProtocol>(lhs: T, rhs: T) -> Bool {
    return lhs.qualifier == rhs.qualifier
}