//
//  Translation.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 23.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

/// Simple structure conforming to the base requirements of `TranslationType`.
///
/// All properties are implemented as constants, as this type is meant to be
/// used like a pure value.
public struct Translation: TranslationType {
    public let languages: (original: AnyLanguage, derived: AnyLanguage)
    public let original: String
    public let derived: Set<String>
    public let context: String?

    public init(languages: (original: AnyLanguage, derived: AnyLanguage),
                original: String,
                derived: Set<String> = [],
                context: String? = nil) {
        self.languages = languages
        self.original = original
        self.derived = derived
        self.context = context
    }
}