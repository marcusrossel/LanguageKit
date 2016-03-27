//
//  LKAnyLanguage.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 23.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

import Foundation

/// A type-erasing wrapper for `LKLanguageType`.
public struct LKAnyLanguage: LKLanguageType {
    public private(set) var identifier: String

    /// A custom implementation of `hashValue` is used to reduce potential hash
    /// collisions with other types (as this type is only a wrapper).
    public var hashValue: Int {
        let specificHashString = "LKAnyLanguage - \(identifier)"
        return specificHashString.hashValue
    }

    public init<T: LKLanguageType>(_ language: T) {
        identifier = language.identifier
    }
}