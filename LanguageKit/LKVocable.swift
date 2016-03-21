//
//  LKVocable.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 20.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//



// MARK: - LKTranslatable

public protocol LKTranslatable {
    var translations: [LKAnyLanguage: Set<String>] { get set }
}



// MARK: - LKVocableType

public protocol LKVocableType: LKTranslatable {
    var style: LKAnyVocableStyle { get set }
    var context: [LKAnyLanguage: String] { get set }
}

extension LKVocableType {
    var context: [LKAnyLanguage: String] {
        return [:]
    }
}



// MARK: - LKVocable

/// The native `LanguageKit` vocable type
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

    public init<VS: LKVocableStyleType, L: LKLanguageType>(style: VS, translations: [L: Set<String>] = [:], context: [L: String] = [:]) {
        self.style = LKAnyVocableStyle(style)
        translations.forEach { language, set in self.translations[LKAnyLanguage(language)] = set }
        context.forEach { language, string in self.context[LKAnyLanguage(language)] = string }
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

        return "\(style.description)\(sortedLanguages)\(sortedSets)\(sortedContextKeys)\(sortedContextValues)".hashValue
    }
}

// MARK: - Operator

@warn_unused_result
public func ==(left: LKVocable, right: LKVocable) -> Bool {
    // use newly added tuple-comparison:
    //
    // return (left.translations, left.style, left.context) == (right.translations, right.style, right.context)

    return left.translations == right.translations &&
        left.style        == right.style &&
        left.context      == right.context
}
