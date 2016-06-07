//
//  AnyVocableType.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 23.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

/// A type-erasing wrapper for `VocableTypeProtocol`.
public struct AnyVocableType: VocableTypeProtocol {
    public private(set) var qualifier: String

    /// A custom implementation of `hashValue` is used to reduce potential hash
    /// collisions with other types (as this type is only a wrapper).
    public var hashValue: Int {
        let specificHashString = "AnyVocableType - \(qualifier)"
        return specificHashString.hashValue
    }

    public init<T: VocableTypeProtocol>(_ vocableStyle: T) {
        qualifier = vocableStyle.qualifier
    }
}