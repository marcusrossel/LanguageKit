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
        public typealias Group = String

        public let group: Group
        /// This property stores the respective `Language`s of a
        /// `Lexicon.Entry`'s `expression` and `translations`.
        public let languages: (expression: Language, translations: Language)

        public private(set) var expression: Expression
        public private(set) var translations: SortedSynonyms

        /// This property stores the respective contextual `String`s of a
        /// `Lexicon.Entry`'s `expression` and `translations`.
        public private(set) var context = (expression: "", translations: "")
    }
}

extension Lexicon.Entry: Comparable { }

/// `Lexicon.Entry`s are considered equal, if all of their stored properties
/// evaluate as equal.
public func ==(lhs: Lexicon.Entry, rhs: Lexicon.Entry) -> Bool {
    let equalGroup = lhs.group == rhs.group
    let equalLanguages = lhs.languages == rhs.languages
    let equalExpression = lhs.expression == rhs.expression
    let equalTranslations = lhs.translations == rhs.translations
    let equalContext = lhs.context == rhs.context

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