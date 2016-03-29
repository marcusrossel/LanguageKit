//
//  LKVocable.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 20.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//


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

    /// If the `originalLanguage` is not found in `languageWordPool`, an empty
    /// array is returned.  
    /// If the `derivedLanguage` is not found in `languageWordPool`,
    /// `LKAnyTranslation`s with an empty `Set` for `derived` will be returned.
    public subscript(originalLanguage: LKAnyLanguage, derivedLanguage: LKAnyLanguage) -> [LKAnyTranslation] {
        guard let originals = languageWordPool[originalLanguage] else { return [] }
        guard !originals.isEmpty else { return [] }

        let translations: [LKTranslation] = originals.map { original in
            let derivedStrings = languageWordPool[derivedLanguage] ?? []
            let contextString = context[originalLanguage]

            return LKTranslation(languages: (originalLanguage, derivedLanguage),
                                 original: original,
                                 derived: derivedStrings,
                                 context: contextString)
        }

        let anyTranslations = translations.map(LKAnyTranslation.init)
        return anyTranslations
    }

    public init<VST: LKVocableStyleType, LT: LKLanguageType>(style: VST, languageWordPool: [LT: Set<String>] = [:], context: [LT: String] = [:]) {
        self.style = LKAnyVocableStyle(style)

        let mappedPool = languageWordPool.mapKeys(LKAnyLanguage.init)
        self.languageWordPool = mappedPool

        let mappedContext = context.mapKeys(LKAnyLanguage.init)
        self.context = mappedContext
    }

    public init<T: LKVocableType>(vocableType: T) {
        style = vocableType.style
        languageWordPool = vocableType.languageWordPool
        context = vocableType.context
    }
}

extension LKVocable: Hashable {
    public var hashValue: Int {
        // The function used to sort `languageWordPool` and `context`'s `keys`.
        let keySort = { (key1: LKAnyLanguage, key2: LKAnyLanguage) in
            key1.identifier < key2.identifier
        }

        let sortedPoolKeys = languageWordPool.keys.sort(keySort)

        // The `Set<String>`s in `languageWordPool` are sorted as follows:
        // (1) Sort the sets by their associated key's `identifier`.
        // (2) Sort the values within each set.
        // (3) Flatten the array of sorted arrays.
        let sortedPoolValues = languageWordPool .sort { pair1, pair2 in
            let (key1, key2) = (pair1.0, pair2.0)
            return key1.identifier < key2.identifier
        }
        .map { (_, set) in
            return set.sort(<)
        }
        .flatMap { $0 }

        let sortedContextKeys = context.keys.sort(keySort)
        let sortedContextValues = context.values.sort(<)

        let hashString = "\(sortedPoolKeys)\(sortedPoolValues)\(style)\(sortedContextKeys)\(sortedContextValues)"
        return hashString.hashValue
    }
}
