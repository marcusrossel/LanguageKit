//
//  Lexicon.Entry.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 09.06.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

extension Lexicon {
    /// * TODO: Describe this type.
    public struct Entry {
        /// A `Lexicon.Entry.Group` is simply supposed to describe the name of a
        /// group/type/kind of a `Lexicon.Entry`, in order to allow their
        /// differentiation.
        ///
        /// Examples for such groups could be `"Word"`, `"Phrase"`, or
        /// `"Question"`.
        ///
        /// * Warning: A `Group` must be defined for any `Entry`. So empty
        /// `String`s will cause initialization to fail.
        public typealias Group = String

        public let group: Group
        /// This property stores the respective `Language`s of a
        /// `Lexicon.Entry`'s `expression` and `translations`.
        public let languages: (expression: Language, translations: Language)

        public let expression: Expression
        public private(set) var translations = SortedSynonyms()

        /// This property stores the respective contextual `String`s of a
        /// `Lexicon.Entry`'s `expression` and `translations`.
        public var context = (expression: "", translations: "")

        /// Inserts a given sequence of `Expression`s into the `Entry`'s
        /// `translations`.
        ///
        /// * Warning: The given `Expression`s should be of the language given
        /// by the `Entry`'s `languages.translations`. No error will occur if
        /// they are not, but the type will not be used as intended.
        ///
        /// * Note: The given `Expression`s do not have to be in any particular
        /// order. This method inserts the `Expression`s in a sorted manner.
        public mutating func insert<S: SequenceType where S.Generator.Element == Expression>(translations newTranslations: S) {
            let insertables = newTranslations.filter { (translation) -> Bool in
                !translations.contains(translation)
            }

            translations = (translations + insertables).sort()
        }

        /// Removes all `Expression`s from `translations`, that occur in the
        /// given sequence.
        public mutating func remove<S: SequenceType where S.Generator.Element == Expression>(translations targets: S) {
            translations = translations.filter { (translation) -> Bool in
                !targets.contains(translation)
            }
        }

        /// * Warning: `group` can not be an empty `String`, or initialization
        /// will fail.
        public init?<S: SequenceType where S.Generator.Element == Expression>(group: Group, languages: (expression: Language, translations: Language), expression: Expression) {
            guard !group.isEmpty else { return nil }

            self.group = group
            self.languages = languages
            self.expression = expression
        }

        /// * Warning: `group` can not be an empty `String`, or initialization
        /// will fail.
        ///
        /// * Note: The given `Expression`s in `translations` do not have to be
        /// in any particular order. The `Entry`'s `translations` property will
        /// be initialized in a sorted manner.
        public init?<S: SequenceType where S.Generator.Element == Expression>(group: Group, languages: (expression: Language, translations: Language), expression: Expression, translations: S, context: (expression: String, translations: String) = ("", "")) {
            guard !group.isEmpty else { return nil }

            self.group = group
            self.languages = languages
            self.expression = expression
            self.translations = translations.sort()
            self.context = context
        }
    }
}

extension Lexicon.Entry: Comparable { }

/// `Lexicon.Entry`s are considered equal, if all of their stored properties
/// evaluate as equal.
public func ==(lhs: Lexicon.Entry, rhs: Lexicon.Entry) -> Bool {
    let equalGroup        = lhs.group        == rhs.group
    let equalLanguages    = lhs.languages    == rhs.languages
    let equalExpression   = lhs.expression   == rhs.expression
    let equalTranslations = lhs.translations == rhs.translations
    let equalContext      = lhs.context      == rhs.context

    return equalGroup        &&
           equalLanguages    &&
           equalExpression   &&
           equalTranslations &&
           equalContext
}

/// `Lexicon.Entry`s are ordered lexographically by their `expression` property.
public func <(lhs: Lexicon.Entry, rhs: Lexicon.Entry) -> Bool {
    return lhs.expression < rhs.expression
}

/// Calls `insert(translations:)` on the given `Entry` with the given parameter.
public func +=<S: SequenceType where S.Generator.Element == Expression>(inout entry: Lexicon.Entry, newTranslations: S) {
    entry.insert(translations: newTranslations)
}

/// Calls `remove(translations:)` on the given `Entry` with the given parameter.
public func -=<S: SequenceType where S.Generator.Element == Expression>(inout entry: Lexicon.Entry, targets: S) {
    entry.remove(translations: targets)
}
