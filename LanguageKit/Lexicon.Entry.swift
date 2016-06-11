//
//  Lexicon.Entry.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 09.06.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

extension Lexicon {
    /// An `Entry` represents the thing you would find when looking up an
    /// expression in a dictionary. It consists of:
    /// - a `group` it belongs to.
    /// - an `expression`, by which one would usually find an entry.
    /// - multiple `translations` of the `expression` in a different language.
    /// - some `context`, which can be used to describe something about the
    /// `expression`.
    ///
    /// Once an `Entry` is initialized you can not change it's `group` or
    /// `expression`, as these properties are fundametal to an `Entry`. If this
    /// behavior is desired, one should consider creating a new `Entry`.
    ///
    /// An `Entry`'s `translations` can be modified, but will have the same
    /// `language` across the entire lifetime of an `Entry`.
    ///
    /// Therefore an `Entry` does not store its `Language`s explicitly, but
    /// rather implicitly in its `expression` and `translations`. This method is
    /// viable, as these properties can never change their `language` once set.
    public struct Entry {
        public let group: Group

        public let expression: Expression
        public private(set) var translations: Synonyms

        /// This property can be used to store some context about an `Entry`'s
        /// `expression`.
        public var context = ""

        /// Inserts the given `Expression` into the `Entry`'s `translations`.
        ///
        /// * Note: Insertion will only be successful if the `Expression`'s
        /// `language` equals the `translations`' `language`.
        ///
        /// * Returns: A `Bool` indicating if insertion was successful.
        public mutating func insert(translation: Expression) -> Bool {
            return translations.insert(translation)
        }

        /// Removes the given `Expression` from the `Entry`'s `translations`.
        public mutating func remove(translation: Expression) {
            translations.remove(translation)
        }

        public init(group: Group, expression: Expression,
                    translations: Synonyms, context: String = "") {
            self.group = group
            self.expression = expression
            self.translations = translations
            self.context = context
        }

        public init(group: Group, expression: Expression,
                    translationLanguage: Language) {
            self.init(
                group: group,
                expression: expression,
                translations: Synonyms(language: translationLanguage)
            )
        }
    }
}

/// Tries to insert the given `Expression`s into the `Entry`s `translations`.
///
/// * Note: Only `Expression`s whose `language` equals the `Entry`'s
/// `translations`' `language`, will be insertable.
public func +=
    <S: SequenceType where S.Generator.Element == Expression>
    (inout entry: Lexicon.Entry, translations: S) {
    // Checks if the given sequence is of type `Synonyms` to allow for more
    // efficient insertion.
    if entry.translations.isEmpty,
       let synonyms = translations as? Synonyms
       where synonyms.language == entry.translations.language {
        entry.translations = synonyms
    } else {
        entry.translations += translations
    }
}

/// Removes the given `Expression`s from the `Entry`s `translations`.
public func -=
    <S: SequenceType where S.Generator.Element == Expression>
    (inout entry: Lexicon.Entry, translations: S) {
    entry.translations -= translations
}

extension Lexicon.Entry: Equatable { }
/// `Lexicon.Entry`s are considered equal, if all of their stored properties
/// evaluate as equal.
public func ==(lhs: Lexicon.Entry, rhs: Lexicon.Entry) -> Bool {
    let equalGroup        = lhs.group        == rhs.group
    let equalExpression   = lhs.expression   == rhs.expression
    let equalTranslations = lhs.translations == rhs.translations
    let equalContext      = lhs.context      == rhs.context

    return equalGroup        &&
           equalExpression   &&
           equalTranslations &&
           equalContext
}

extension Lexicon.Entry: Comparable { }
/// `Lexicon.Entry`s are ordered lexographically by their `expression` property.
public func <(lhs: Lexicon.Entry, rhs: Lexicon.Entry) -> Bool {
    return lhs.expression < rhs.expression
}