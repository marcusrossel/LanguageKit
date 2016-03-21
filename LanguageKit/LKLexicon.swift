//
//  LKLexicon.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 20.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//



// MARK: - LKLexicon

/// A native `LanguageKit` type which allows `LKVocableType`s to be used
/// collectively
public struct LKLexicon<V: LKVocableType where V: Hashable> {
    // MARK: - Private Storage

    private var _storage: Set<V> = []

    // MARK: - Public Methods

    public mutating func insertVocable(vocable: V) {
        _storage.insert(vocable)
    }

    public mutating func removeVocable(vocable: V) {
        _storage.remove(vocable)
    }

    public subscript(vocableStyle: LKAnyVocableStyle) -> LKLexicon {
        get {
            let vocables = Set(_storage.filter { $0.style == vocableStyle })
            return LKLexicon(vocables: vocables)
        }
    }

    public subscript(originalLanguage: LKAnyLanguage, translationLanguage: LKAnyLanguage) -> Set<LKAnyTranslation> {
        get {
            let originalsAndTranslationsAndContext = _storage.map { vocable in
                (vocable.translations[originalLanguage] ?? [], vocable.translations[translationLanguage] ?? [], vocable.context[originalLanguage])
            }

            let translations = originalsAndTranslationsAndContext.map { (originals, translations, context) in
                originals.map {
                    LKAnyTranslation(LKTranslation(languages: (originalLanguage, translationLanguage), original: $0, translations: translations, context: context))
                }
            }
            
            let flatTranslations = translations.flatMap { $0 }

            return Set(flatTranslations)
        }
    }

    // MARK: - Initialization

    public init<S: SequenceType where S.Generator.Element == V>(vocables: S) {
        _storage = Set(vocables)
    }
}

// MARK: - Protocol Conformances

extension LKLexicon: ArrayLiteralConvertible {
    public init(arrayLiteral elements: V...) {
        self.init(vocables: elements)
    }
}

extension LKLexicon: Hashable {
    public var hashValue: Int {
        return _storage.hashValue
    }
}

// MARK: - Operator

@warn_unused_result
public func ==<V>(left: LKLexicon<V>, right: LKLexicon<V>) -> Bool {
    return left._storage == right._storage
}
