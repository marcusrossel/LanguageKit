//
//  LKVocable.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 20.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

import Foundation

/// The native *LanguageKit* vocable type.
public struct LKVocable: LKVocableType {
    /// An embedded `LKVocableStyleType` which can be used for convenience.
    public enum Style: String, LKVocableStyleType {
        case Word
        case Phrase
        public var qualifier: String { return "\(self)" }
    }

    public var languageWordPool: [LKAnyLanguage: Set<String>] = [:]
    public var style: LKAnyVocableStyle
    public var context: [LKAnyLanguage: String] = [:]

    /// This subscript gives direct access to `LKVocable`'s `languageWordPool`
    /// dictionary.
    public subscript(language: LKAnyLanguage) -> Set<String>? {
        get { return languageWordPool[language] }
        set { languageWordPool[language] = newValue }
    }

    /// If the `original` language is not found in `languageWordPool`, an empty
    /// array is returned.  
    /// If the `derived` language is not found in `languageWordPool`,
    /// `LKAnyTranslation`s with an empty `Set` for `derived` will be returned.
    public subscript(original oLang: LKAnyLanguage, derived dLang: LKAnyLanguage) -> [LKAnyTranslation] {
        guard let originals = languageWordPool[oLang] else { return [] }
        guard !originals.isEmpty else { return [] }

        let translations: [LKTranslation] = originals.map { original in
            let derivedStrings = languageWordPool[dLang] ?? []
            let contextString = context[oLang]

            return LKTranslation(languages: (oLang, dLang),
                                 original: original,
                                 derived: derivedStrings,
                                 context: contextString)
        }

        let anyTranslations = translations.map(LKAnyTranslation.init)
        return anyTranslations
    }

    public init<VST: LKVocableStyleType, LT: LKLanguageType>(style: VST, languageWordPool: [LT: Set<String>] = [:], context: [LT: String] = [:]) {
        self.style = LKAnyVocableStyle(style)

        // If `LT` is `LKAnyLanguage`, the computationally intensive key-mapping
        // can be skipped.
        if LT == LKAnyLanguage {
            self.languageWordPool = languageWordPool
            self.context = context
        } else {
            let mappedPool = languageWordPool.mapKeys(LKAnyLanguage.init)
            self.languageWordPool = mappedPool

            let mappedContext = context.mapKeys(LKAnyLanguage.init)
            self.context = mappedContext
        }
    }

    public init<T: LKVocableType>(vocableType: T) {
        style = vocableType.style
        languageWordPool = vocableType.languageWordPool
        context = vocableType.context
    }
}

/// TODO: Fix this
/*
extension LKVocable: Hashable {
    public var hashValue: Int {
        // dictionary key- and value-sorting is needed to ensure stable hash
        // values across multiple calls

        let sortedLanguages = Array(languageWordPool.keys).sort {
            $0.identifier < $1.identifier
        }

        let sortedSets = Array(languageWordPool.values).flatMap { $0 }.sort()

        let sortedContextKeys = Array(context.keys).sort {
            $0.identifier < $1.identifier
        }
        
        let sortedContextValues = Array(context.values).sort()

        let combinedString = "\(style.qualifier)\(sortedLanguages)\(sortedSets)\(sortedContextKeys)\(sortedContextValues)"

        return combinedString.hashValue*
    }
}*/

@warn_unused_result
public func ==<T: LKVocableType>(lhs: T, rhs: T) -> Bool {
    return lhs.languageWordPool == rhs.languageWordPool &&
           lhs.style            == rhs.style            &&
           lhs.context          == rhs.context
}
