//
//  Lexicon_.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 31.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//


/// A native *LanguageKit* type which allows `Vocable`s
/// to be used collectively.
///
/// An `Lexion` contains a set of vocables, which are unique in their meaning.
/// Each vocable is defined by the meaning of the *word/phrase/etc.* that it
/// contains, not by the language it represents.
/// When a connection can be made between vocables, they are merged into one,
/// therefore bundeling words/phrases/etc. of the same meaning into one vocable.
/// The result of inserting information into the lexicon, might therefore an
/// increase in size of certain vocables, not an increase in the number of
/// vocables.
public struct Lexicon_ {
    // TEMPORARY
    public typealias V = Vocable

    private var _storage: Set<V> = []

/*********/

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

/*********/

    /// Creates an `Vocable` from the given parameters, and calls
    /// `Lexicon_.insert.(vocable:)`
    public mutating func insert(translation translation: AnyTranslation, style: AnyVocableStyle) {
        let vocable = Vocable(style: style, translation: translation)
        insert(vocable: vocable)
    }

    /// Creates an `Vocable` from the given parameters, and calls
    /// `Lexicon_.remove.(vocable:)`
    public mutating func remove(translation translation: AnyTranslation, style: AnyVocableStyle) {
        let vocable = Vocable(style: style, translation: translation)
        remove(vocable: vocable)
    }

    /// Creates an `Vocable` from the given parameters, and calls
    /// `Lexicon_.insert.(vocable:)`
    public mutating func insert(string string: String, as style: AnyVocableStyle, for language: AnyLanguage) {
        let vocable = Vocable(style: style,
                              languageWordPool: [language: Set([string])],
                              context: [:])

        insert(vocable: vocable)
    }

    /// Creates an `Vocable` from the given parameters, and calls
    /// `Lexicon_.remove.(vocable:)`
    public mutating func remove(string string: String, as style: AnyVocableStyle, for language: AnyLanguage) {
        let vocable = Vocable(style: style,
                                languageWordPool: [language: Set([string])],
                                context: [:])

        remove(vocable: vocable)
    }

    /// Default parameters do not seem to be allowed for subscripts yet.
    /// To ignore the `vocableStyle`, it should therefore be passed a value of
    /// `nil`.
    public subscript(originalLanguage oLang: AnyLanguage, derivedLanguage dLang: AnyLanguage, vocableStyle vStyle: AnyVocableStyle?) -> Set<AnyTranslation> {
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

extension Lexicon_: ArrayLiteralConvertible {
    public init(arrayLiteral elements: V...) {
        self.init(vocables: elements)
    }
}

extension Lexicon_: Hashable {
    public var hashValue: Int { return _storage.hashValue }
}

@warn_unused_result
public func ==(lhs: Lexicon_, rhs: Lexicon_) -> Bool {
    return lhs._storage == rhs._storage
}
