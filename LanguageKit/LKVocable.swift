//
//  Vocable.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 20.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

/// The native *LanguageKit* vocable type.
///
/// An `Vocable` bundels *words/phrases/etc.* of the same meaning into one
/// data structure. The connection between the *words/phrases/etc.* is therefore
/// semantic, not language-based.
public struct Vocable: VocableType {
    /// An embedded `VocableStyleType` which can be used for convenience.
    public enum Style: String, VocableStyleType {
        case Word
        case Phrase
        public var qualifier: String { return "\(self)" }
    }

    public var languageWordPool: [AnyLanguage: Set<String>] = [:]
    public var style: AnyVocableStyle
    public var context: [AnyLanguage: String] = [:]

    /// This subscript gives direct access to `Vocable`'s `languageWordPool`
    /// dictionary.
    public subscript(language: AnyLanguage) -> Set<String> {
        get { return languageWordPool[language] ?? [] }
        set { languageWordPool[language] = newValue }
    }

    /// If the `originalLanguage` is not found in `languageWordPool`, an empty
    /// array is returned.  
    /// If the `derivedLanguage` is not found in `languageWordPool`,
    /// `AnyTranslation`s with an empty `Set` for `derived` will be returned.
    public subscript(originalLanguage: AnyLanguage, derivedLanguage: AnyLanguage) -> [AnyTranslation] {
        guard let originals = languageWordPool[originalLanguage] else { return [] }
        guard !originals.isEmpty else { return [] }

        let translations: [Translation] = originals.map { original in
            let derivedStrings = languageWordPool[derivedLanguage] ?? []
            let contextString = context[originalLanguage]

            return Translation(languages: (originalLanguage, derivedLanguage),
                               original: original,
                               derived: derivedStrings,
                               context: contextString)
        }

        let anyTranslations = translations.map(AnyTranslation.init)
        return anyTranslations
    }

    /// It is more efficient to initialize an `VocableType` and call the
    /// `init(vocableType:)` initializer, than using this one.
    public init<VST: VocableStyleType, LT: LanguageType>(style: VST, languageWordPool: [LT: Set<String>] = [:], context: [LT: String] = [:]) {
        self.style = AnyVocableStyle(style)

        let mappedPool = languageWordPool.mapKeys(AnyLanguage.init)
        self.languageWordPool = mappedPool

        let mappedContext = context.mapKeys(AnyLanguage.init)
        self.context = mappedContext
    }

    public init<T: VocableType>(vocableType: T) {
        style = vocableType.style
        languageWordPool = vocableType.languageWordPool
        context = vocableType.context
    }

    public init(style: AnyVocableStyle, translation: AnyTranslation) {
        self.style = style

        let (oLang, dLang) = (translation.languages.original, translation.languages.derived)
        let originalSet = Set([translation.original])
        let pool = [oLang: originalSet, dLang: translation.derived]

        self.languageWordPool = pool

        self.context = [oLang: translation.context ?? ""]
    }
}

extension Vocable: Hashable {
    public var hashValue: Int {
        // The function used to sort `languageWordPool` and `context`'s `keys`.
        let keySort = { (key1: AnyLanguage, key2: AnyLanguage) in
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
        .flatten()

        let sortedContextKeys = context.keys.sort(keySort)
        let sortedContextValues = context.values.sort(<)

        let hashString = "\(sortedPoolKeys)\(sortedPoolValues)\(style)\(sortedContextKeys)\(sortedContextValues)"
        return hashString.hashValue
    }
}
