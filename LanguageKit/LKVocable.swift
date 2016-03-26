//
//  LKVocable.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 20.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

/// The native `LanguageKit` vocable type.
public struct LKVocable: LKVocableType {

    // MARK: - Nested Types

    /// Nested `LKVocableStyleType` which can be used for convenience
    public enum Style: String, LKVocableStyleType {
        case Word
        case Phrase

        public var description: String {
            return "\(self)"
        }
    }

    // MARK: - Properties

    public var style: LKAnyVocableStyle
    public var translations: [LKAnyLanguage: Set<String>] = [:]

    /// Use this property to store additional information about the vocable
    public var context: [LKAnyLanguage: String] = [:]

    // MARK: - Subscripts

    /// This subscript gives direct access to `VLKocable`'s `translations`
    /// property
    public subscript(language: LKAnyLanguage) -> Set<String>? {
        get { return translations[language] }
        set { translations[language] = newValue }
    }

    // MARK: - Initialization

    public init<VS: LKVocableStyleType, L: LKLanguageType>
        (style: VS, translations: [L: Set<String>] = [:],
         context: [L: String] = [:]) {
        self.style = LKAnyVocableStyle(style)
        translations.forEach {
            language, set in self.translations[LKAnyLanguage(language)] = set
        }

        context.forEach {
            language, string in self.context[LKAnyLanguage(language)] = string
        }
    }

    public init(vocableType: LKVocableType) {
        self.style = vocableType.style
        self.translations = vocableType.translations
    }
}

// MARK: - Protocol Conformances

extension LKVocable: Hashable {
    public var hashValue: Int {
        // dictionary key- and value-sorting is needed to ensure stable hash
        // values across multiple calls

        let sortedLanguages = Array(translations.keys).sort {
            $0.description < $1.description
        }

        let sortedSets = Array(translations.values).flatMap { $0 }.sort()

        let sortedContextKeys = Array(context.keys).sort {
            $0.description < $1.description
        }
        
        let sortedContextValues = Array(context.values).sort()

        let combinedString = "\(style.description)\(sortedLanguages)" +
                             "\(sortedSets)\(sortedContextKeys)" +
                             "\(sortedContextValues)"

        return combinedString.hashValue
    }
}

// MARK: - Operator

@warn_unused_result
public func ==(lhs: LKVocable, rhs: LKVocable) -> Bool {
    return lhs.translations == rhs.translations &&
           lhs.style        == rhs.style &&
           lhs.context      == rhs.context
}
