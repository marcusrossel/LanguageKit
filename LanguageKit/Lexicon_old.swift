//
//  Lexicon.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 20.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

/// A native *LanguageKit* type which allows types conforming to
/// `VocableProtocol` to be used collectively.
///
/// An `Lexion` contains a set of vocables - some type confroming to
/// `VocableProtocol` - which are unique in their meaning. Each vocable is
/// defined by the meaning of the *word/phrase/etc.* that it contains, not by
/// the language it represents.
/// When a connection can be made between vocables, they are merged into one,
/// therefore bundeling words/phrases/etc. of the same meaning into one vocable.
/// The result of inserting information into the lexicon, might therefore an
/// increase in size of certain vocables, not an increase in the number of
/// vocables.
public struct Lexicon___<V: VocableProtocol where V: Hashable> {
    private var _storage: Set<V> = []

    public mutating func insert(vocable vocable: V) {
        // insert... merge ... etc.
    }

    public mutating func remove(vocable vocable: V) {
        // either (1) or (2)
     
        // (1)
        // remove every component of `vocable` from `_storage` (not required to
        // be a strikt subset)
     
        // (2)
        // figure out if vocable is subset of other vocable. it it's a strickt
        // subvocable... remove it from supervocable
        // if it's not a strict subvocable. dont remove it
    }

    public mutating func insert(translation translation: AnyTranslation, style: AnyVocableType) {
        let vocable = V(style: style, translation: translation)
        insert(vocable: vocable)
    }

    public mutating func remove(translation translation: AnyTranslation, style: AnyVocableType) {
        // same as with `removeVocable`. if the translation is not a strickt
        // subset... nothing happens
    }

    /// Default parameters do not seem to be allowed for subscripts yet.
    /// To ignore the `vocableStyle`, it should therefore be passed a value of
    /// `nil`.
    public subscript(originalLanguage oLang: AnyLanguage, derivedLanguage dLang: AnyLanguage, vocableStyle vStyle: AnyVocableType?) -> Set<AnyTranslation> {
        let vocablePool: [V]

        if let style = vStyle {
            vocablePool = _storage.filter { vocable in vocable.style == style }
        } else {
            vocablePool = Array(_storage)
        }

        let translations = vocablePool.map { vocable in
            return vocable[oLang, dLang]
        }
        .flatten()

        return Set(translations)
    }

    public init<S: SequenceType where S.Generator.Element == V>(vocables: S) {
        _storage = Set(vocables)
    }
}

extension Lexicon: ArrayLiteralConvertible {
    public init(arrayLiteral elements: V...) {
        self.init(vocables: elements)
    }
}

extension Lexicon: Hashable {
    public var hashValue: Int { return _storage.hashValue }
}

@warn_unused_result
public func ==<T>(lhs: Lexicon<T>, rhs: Lexicon<T>) -> Bool {
    return lhs._storage == rhs._storage
}
