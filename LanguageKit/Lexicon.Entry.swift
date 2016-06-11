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
        public let group: Group
        /// This property stores the respective `Language`s of a
        /// `Lexicon.Entry`'s `expression` and `translations`.
        public let languages: (expression: Language, translations: Language)

        public let expression: Expression
        public private(set) var translations: Synonyms

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
            let insertables = newTranslations.filter { translation in
                !translations.contains(translation)
            }

            translations += insertables
        }

        /// Removes all `Expression`s from `translations`, that occur in the
        /// given sequence.
        public mutating func remove<S: SequenceType where S.Generator.Element == Expression>(translations targets: S) {
            translations -= targets
        }

        public init(group: Group, languages: (expression: Language, translations: Language), expression: Expression) {
            self.group = group
            self.languages = languages
            self.expression = expression
            self.translations = Synonyms(language: languages.translations)
        }

        /// * Note: The given `Expression`s in `translations` do not have to be
        /// in any particular order. The `Entry`'s `translations` property will
        /// be initialized in a sorted manner.
        public init<S: SequenceType where S.Generator.Element == Expression>(group: Group, languages: (expression: Language, translations: Language), expression: Expression, translations: S, context: (expression: String, translations: String) = ("", "")) {
            self.init(group: group, languages: languages, expression: expression)
            self.translations = Synonyms(expressions: translations, language: languages.translations)
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
