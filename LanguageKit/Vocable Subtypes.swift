//
//  Vocable.Slice.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 09.06.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

/*extension Vocable {
    /// A `Vocable.Kind` is simply supposed to describe the name of a
    /// kind/type/style of a vocable, in order to allow their grouping and
    /// differentiation.
    /// 
    /// Examples for vocable-kinds could be `"Word"`, `"Phrase"`, or
    /// `"Question"`.
    public typealias Kind = String
}*/

extension Vocable {
    /// A `Vocable.Slice` represents a focused/reduced view on a `Vocable`'s
    /// expressions. It focuses on one word/phrase/etc. of one certain language,
    /// and all of its associated expressions of another language.
    ///
    /// It can be compared to what one would find when looking up one certain
    /// word/phrase/etc. in a dictionary - a word and it's different
    /// translations.
    ///
    /// * Note: A `Vocable.Slice` is supposed to be used like a fixed value,
    /// which is why all of it's properties are declared with `let`.
    public struct Slice {
        public let kind: Lexicon.Entry.Type
        /// This porperty stores a word/phrase/etc. and its associated
        /// `SortedExpression` of another language.
        public let expressions: (origin: Expression, associated: SortedSynonyms)
        /// This property stores the respective `Language`s of a
        /// `Vocable.Slice.expressions`' values.
        ///
        /// * Seealso: `Vocable.Slice.expressions`
        public let languages: (origin: Language, associated: Language)
        /// This property stores the respective context `String`s of a
        /// `Vocable.Slice.expressions`' values.
        ///
        /// * Seealso: `Vocable.Slice.expressions`
        public let contexts: (origin: String, associated: String)
    }
}

extension Vocable.Slice: Hashable {
    public var hashValue: Int {
        return "\(kind)\(languages)\(expressions)\(contexts)".hashValue
    }
}

/// `Vocable.Slice`s are considered equal, if all of their stored properties
/// evaluate as equal. They must therefore:
/// - be of the same `kind`
/// - use the same `languages`
/// - store the same `expressions`
/// - have the same `contexts`
public func ==(lhs: Vocable.Slice, rhs: Vocable.Slice) -> Bool {
    let equalKind = lhs.kind == rhs.kind
    let equalLanguages = lhs.languages == rhs.languages
    let equalOrigin = lhs.expressions.0 == rhs.expressions.0
    let equalAssociated = lhs.expressions.1 == rhs.expressions.1
    let equalExpressions = equalOrigin && equalAssociated
    let equalContexts = lhs.contexts == rhs.contexts

    return equalKind && equalLanguages && equalExpressions && equalContexts
}