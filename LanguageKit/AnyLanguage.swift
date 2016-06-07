//
//  AnyLanguage.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 23.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

/// A type-erasing wrapper for `LanguageProtocol`.
public struct AnyLanguage: LanguageProtocol {
    public private(set) var identifier: String

    /// A custom implementation of `hashValue` is used to reduce potential hash
    /// collisions with other types (as this type is only a wrapper).
    public var hashValue: Int {
        let specificHashString = "AnyLanguage - \(identifier)"
        return specificHashString.hashValue
    }

    public init<T: LanguageProtocol>(_ language: T) {
        identifier = language.identifier
    }
}