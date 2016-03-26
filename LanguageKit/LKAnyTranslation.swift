//
//  LKAnyTranslation.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 23.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

import Foundation

/// A type-erasing wrapper for `LKTranslationType`.
public struct LKAnyTranslation: LKTranslationType {
    public var languages: (original: LKAnyLanguage, translations: LKAnyLanguage)
    public var original: String
    public var translations: Set<String>
    public var context: String?

    /// A custom implementation of `hashValue` is used to reduce potential
    /// hash collisions with other types (as this type is only a wrapper)
    public var hashValue: Int {
        return "LKAnyTranslation - \(languages.original)\(languages.translations)\(original)\(translations.sort()))".hashValue
    }

    public init<T: LKTranslationType>(_ translation: T) {
        languages = translation.languages
        original = translation.original
        translations = translation.translations
        context = translation.context
    }
}