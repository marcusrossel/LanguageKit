//
//  LKLexicon.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 20.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

import Foundation

/// A native `LanguageKit` type which allows types conforming to `LKVocableType`
/// to be used collectively.
public struct LKLexicon<V: LKVocableType where V: Hashable> {

    private var _storage: Set<V> = []

    public mutating func insertVocable(vocable: V) {
        _storage.insert(vocable)
    }

    public mutating func removeVocable(vocable: V) {
        _storage.remove(vocable)
    }

    public subscript(vocableStyle: LKAnyVocableStyle) -> LKLexicon {
        return LKLexicon(vocables: _storage.filter { $0.style == vocableStyle })
    }

    public subscript(originalLanguage: LKAnyLanguage, translationLanguage: LKAnyLanguage) -> Set<LKAnyTranslation> {
        let originalsAndTranslationsAndContext = _storage.map { vocable in
            (vocable.translations[originalLanguage] ?? [],
                vocable.translations[translationLanguage] ?? [],
                vocable.context[originalLanguage])
        }

        let translations = originalsAndTranslationsAndContext.map {
            (originals, translations, context) in
            originals.map {
                LKAnyTranslation(LKTranslation(languages: (originalLanguage, translationLanguage), original: $0, translations: translations, context: context))
            }
        }

        let flatTranslations = translations.flatMap { $0 }

        return Set(flatTranslations)
    }

    public init<S: SequenceType where S.Generator.Element == V>(vocables: S) {
        _storage = Set(vocables)
    }
}

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

@warn_unused_result
public func ==<V>(lhs: LKLexicon<V>, rhs: LKLexicon<V>) -> Bool {
    return lhs._storage == rhs._storage
}
