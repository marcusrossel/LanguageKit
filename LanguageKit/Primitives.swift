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

/// A word or phrase of a certain group in a certain language.
///
/// * Note: An `Expression` can not be initialized with an empty `String`.
public struct Expression {
    public let value: String
    public let group: Group
    public let language: Language

    /// * Note: This initializer fails, if passed an empty `String`.
    public init!(_ value: String, in language: Language, group: Group) {
        guard !value.isEmpty else { return nil }
        self.value = value
        self.group = group
        self.language = language
    }
}

extension Expression: Hashable {
    public var hashValue: Int {
        // Removing the space would lead to more hash collisions.
        return "\(value) \(group) \(language)".hashValue
    }
}

extension Expression: Equatable { }
/// `Expression`s are considered equal, if all of their stored properties
/// evaluate as equal.
public func ==(lhs: Expression, rhs: Expression) -> Bool {
    return lhs.value == rhs.value &&
           lhs.group == rhs.group &&
           lhs.language == rhs.language
}

extension Expression: Comparable { }
/// `Expression`s are compared on three levels:
/// - If the `Expression`s `value`s differ, they will be compared
/// lexographically.
/// - If the `Expression`s `value`s do not differ, the `language`s will be
/// compared instead.
/// - If the `Expression`s `language`s do not differ either, the `group`s will
/// be compared instead.
public func <(lhs: Expression, rhs: Expression) -> Bool {
    if lhs.value != rhs.value {
        return lhs.value < rhs.value
    } else if lhs.language != rhs.language {
        return lhs.language < rhs.language
    } else {
        return lhs.group < rhs.group
    }
}

extension Expression {
    /// An `Expression.Group` is simply supposed to describe the name of a
    /// group/type/kind of a `Lexicon.Entry`, in order to allow their
    /// differentiation.
    ///
    /// Examples for such groups could be `"Word"`, `"Phrase"`, or
    /// `"Question"`.
    ///
    /// * Note: An `Expression.Group` can not be initialized with an empty
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

extension Expression.Group: Hashable {
    public var hashValue: Int {
        return title.hashValue
    }
}

extension Expression.Group: Equatable { }
/// `Expression.Group`s are considered equal, if their `title`s evaluate as
/// equal.
public func ==(lhs: Expression.Group, rhs: Expression.Group) -> Bool {
    return lhs.title == rhs.title
}

extension Expression.Group: Comparable { }
/// `Expression.Group`s compare lexographically by their `title`.
public func <(lhs: Expression.Group, rhs: Expression.Group) -> Bool {
    return lhs.title < rhs.title
}
