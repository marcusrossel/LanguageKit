//
//  Primitives.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 11.06.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

/// A `Language` is simply supposed to represent the name of a language, in
/// order to allow differentiation of types used in association with it (e.g.
/// expressions).
///
/// * Note: A `Language` can not be initialized with an empty `String`.
public struct Language {
    public let title: String

    /// * Note: This initializer fails, if passed an empty `String`.
    public init!(_ title: String) {
        guard !title.isEmpty else { return nil }
        self.title = title
    }
}

extension Language: Hashable {
    public var hashValue: Int {
        return title.hashValue
    }
}

extension Language: Equatable { }
/// `Language`s are considered equal, if their `title`s evaluate as equal.
public func ==(lhs: Language, rhs: Language) -> Bool {
    return lhs.title == rhs.title
}

extension Language: Comparable { }
/// `Language`s compare lexogrphically by their `title`.
public func <(lhs: Language, rhs: Language) -> Bool {
    return lhs.title < rhs.title
}

/// A word or phrase in a certain language.
///
/// * Note: An `Expression` can not be initialized with an empty `String`.
public struct Expression {
    public let value: String
    public let language: Language

    /// * Note: This initializer fails, if passed an empty `String`.
    public init!(_ value: String, in language: Language) {
        guard !value.isEmpty else { return nil }
        self.value = value
        self.language = language
    }
}

extension Expression: Hashable {
    public var hashValue: Int {
        // Removing the space would lead to more hash collisions.
        return "\(value) \(language)".hashValue
    }
}

extension Expression: Equatable { }
/// `Expression`s are considered equal, if both of their stored properties
/// evaluate as equal.
public func ==(lhs: Expression, rhs: Expression) -> Bool {
    return lhs.value == rhs.value && lhs.language == rhs.language
}

extension Expression: Comparable { }
/// `Expression`s are compared on two levels:
/// - If the `Expression`s `value`s differ, they will be compared
/// lexographically.
/// - If the `Expression`s `value`s do not differ, the `languages` will be
/// compared instead.
public func <(lhs: Expression, rhs: Expression) -> Bool {
    if lhs.value != rhs.value {
        return lhs.value < rhs.value
    } else {
        return lhs.language < rhs.language
    }
}

extension Lexicon.Entry {
    /// A `Lexicon.Entry.Group` is simply supposed to describe the name of a
    /// group/type/kind of a `Lexicon.Entry`, in order to allow their
    /// differentiation.
    ///
    /// Examples for such groups could be `"Word"`, `"Phrase"`, or
    /// `"Question"`.
    ///
    /// * Note: A `Lexicon.Entry.Group` can not be initialized with an empty
    /// `String`.
    public struct Group {
        public let title: String

        /// * Note: This initializer fails, if passed an empty `String`.
        public init!(_ title: String) {
            guard !title.isEmpty else { return nil }
            self.title = title
        }
    }
}

extension Lexicon.Entry.Group: Hashable {
    public var hashValue: Int {
        return title.hashValue
    }
}

extension Lexicon.Entry.Group: Equatable { }
/// `Lexicon.Entry.Group`s are considered equal, if their `title`s evaluate as
/// equal.
public func ==(lhs: Lexicon.Entry.Group, rhs: Lexicon.Entry.Group) -> Bool {
    return lhs.title == rhs.title
}

extension Lexicon.Entry.Group: Comparable { }
/// `Lexicon.Entry.Group`s compare lexographically by their `title`.
public func <(lhs: Lexicon.Entry.Group, rhs: Lexicon.Entry.Group) -> Bool {
    return lhs.title < rhs.title
}
