//
//  LKAnyVocableStyle.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 23.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

import Foundation

/// A type-erasing wrapper for `LKVocableStyleType`.
public struct LKAnyVocableStyle: LKVocableStyleType {
    public private(set) var description: String

    /// A custom implementation of `hashValue` is used to reduce potential hash
    /// collisions with other types (as this type is only a wrapper).
    public var hashValue: Int {
        return "LKAnyVocableStyle - \(description)".hashValue
    }

    public init<T: LKVocableStyleType>(_ vocableStyle: T) {
        description = vocableStyle.description
    }
}