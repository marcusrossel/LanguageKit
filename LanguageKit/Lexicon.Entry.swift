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
    /// - an `expression`, by which one would usually find an entry.
    /// - multiple `translations` of the `expression` in a different language.
    ///
    /// Once an `Entry` is initialized you can not change its `expression`, as 
    /// this property is fundametal to an `Entry`. If this behavior is desired,
    /// one should consider creating a new `Entry`.
    ///
    /// An `Entry`'s `translations` can be modified, but will have the same
    /// `Language` across the entire lifetime of an `Entry`.
    ///
    /// Therefore an `Entry` does not store its `Language`s explicitly, but
    /// rather implicitly in its `expression` and `translations`. This method is
    /// viable, as these properties can never change their `Language` once set.
    ///
    /// An `Entry` does not have a fixed `Expression.Group` it enforces, as some
    /// multi-word expressions can be translated as one word in other languages,
    /// or vice versa.
    public struct Entry {
        public let expression: Expression
        public private(set) var translations: Synonyms

        public var languages: (expression: Language, translations: Language) {
            return (expression.language, translations.language)
        }

        public var context: String? {
            return expression.context
        }

        internal var flipped: [Entry] {
            let oldExpression = Synonyms(expressions: [expression],
                                         language: expression.language)

            return translations.map { translation in
                return Entry(expression: translation,
                             translations: oldExpression)
            }
        }

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

        public init(expression: Expression, translations: Synonyms,
                    context: String = "") {
            self.expression = expression
            self.translations = translations
        }

        public init(expression: Expression, translationLanguage: Language,
                    context: String = "") {
            self.init(
                expression: expression,
                translations: Synonyms(language: translationLanguage),
                context: context
            )
        }
    }
}

/// Tries to insert the given `Expression`s into the `Entry`s `translations`.
///
/// * Note: Only `Expression`s whose `language` equals the `Entry`'s
/// `translations`' `language`, will be insertable.
public func +=<S: Sequence where S.Iterator.Element == Expression>(
    entry: inout Lexicon.Entry,
    translations: S
) {
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
public func -=<S: Sequence where S.Iterator.Element == Expression>(
    entry: inout Lexicon.Entry,
    translations: S
) {
    entry.translations -= translations
}

extension Lexicon.Entry: Equatable { }
/// `Lexicon.Entry`s are considered equal, if all of their stored properties
/// evaluate as equal.
public func ==(lhs: Lexicon.Entry, rhs: Lexicon.Entry) -> Bool {
    return lhs.expression   == rhs.expression &&
           lhs.translations == rhs.translations
}

extension Lexicon.Entry: Hashable {
    public var hashValue: Int {
        let strings = [expression.value] + translations.map { expression in
            expression.value
        }

        return String(strings).hashValue
    }
}

extension Lexicon.Entry: Comparable { }
/// `Lexicon.Entry`s are compared by their `expression` property.
public func <(lhs: Lexicon.Entry, rhs: Lexicon.Entry) -> Bool {
    return lhs.expression < rhs.expression
}
