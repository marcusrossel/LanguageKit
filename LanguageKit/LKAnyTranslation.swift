//
//  LKAnyTranslation.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 23.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

/// A type-erasing wrapper for `LKTranslationType`.
public struct LKAnyTranslation: LKTranslationType {
    public var languages: (original: LKAnyLanguage, derived: LKAnyLanguage)
    public var original: String
    public var derived: Set<String>
    public var context: String?

    /// A custom implementation of `hashValue` is used to reduce potential
    /// hash collisions with other types (as this type is only a wrapper).
    public var hashValue: Int {
        let propertiesString = "LKAnyTranslation - \(languages)\(original)\(derived.sort())\(context)"
        return propertiesString.hashValue
    }

    public init<T: LKTranslationType>(_ translation: T) {
        languages = translation.languages
        original = translation.original
        derived = translation.derived
        context = translation.context
    }
}