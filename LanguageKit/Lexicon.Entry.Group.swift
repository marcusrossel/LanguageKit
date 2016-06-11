//
//  Lexicon.Entry.Group.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 11.06.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

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