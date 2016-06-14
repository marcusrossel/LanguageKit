//
//  Lexicon.Page.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 09.06.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

extension Lexicon {
    /// A `Page` represents a collection of `Entry`s of cenrtain
    /// `Expression.Group`s and `Language`s.
    ///
    /// The `groups` are set at the point of initialization, and can't be
    /// changed once set.
    ///
    /// The `Language`s of the `Entry`s `expression`s and `translations` are not
    /// fixed, but promised to be consistent across all `Entry`s.
    /// This means, that if the `entries` are all removed, one can populate them
    /// with any new `Language`s.
    public struct Page {
        /// A set storing all of the `Entry.Group`s, which the `Page`'s `Entry`s
        /// belong to. An empty set, means that no specific `Entry.Group` was
        /// selected.
        public let groups: Set<Expression.Group>

        /// A sorted set storing all of the `Entry`s found on this `Page`.
        public private(set) var entries = [Entry]()

        public var languages: (expressions: Language, translations: Language)? {
            guard let entry = entries.first else { return nil }
            return (entry.languages.expression, entry.languages.translations)
        }

        /// A convenience method, to check if a given `Entry` satisfies all of
        /// the conditions needed, to be insertable into the `Page`'s `entires`.
        private func canInsert(entry: Entry) -> Bool {
            let isUnique = !entries.contains(entry)
            let validGroup = groups.contains(entry.expression.group)
            let rightLanguages: Bool
            if let requiredLanguages = languages {
                rightLanguages = entry.languages == requiredLanguages
            } else {
                rightLanguages = true
            }

            return isUnique && validGroup && rightLanguages
        }

        /// Inserts the given `Entry` into the sorted list of `entries`.
        ///
        /// * Precondition: `entry` must have the same `languages` and belong to
        /// one of the `Entry.Group`s stored in the `Page`'s `groups`, to be
        /// insertable.
        ///
        /// * Returns: A `Bool` indicating whether `entry` was succesfully
        /// inserted.
        public mutating func insert(entry newEntry: Entry) -> Bool {
            guard canInsert(newEntry) else { return false }

            for (index, entry) in entries.enumerated() {
                if newEntry < entry {
                    entries.insert(newEntry, at: index)
                    return true
                }
            }

            entries.append(newEntry)
            return true
        }

        /// Inserts the given sequence of `Entry`s into the `Page`'s `entries`.
        ///
        /// * Important: Only the `Entries`, which are of the same `languages`
        /// and belong to one of the `Entry.Group`s stored in the `Page`'s
        /// `groups`, will be inserted.
        ///
        /// * Parameter entries: Some type conforming to the `SequenceType`
        /// protocol, whose elements are `Entry`s.
        /// * Returns: The number of `Entry`s that were succesfully inserted.
        public mutating func insert
            <S: Sequence where S.Iterator.Element == Entry>
            (entries newEntries: S) -> Int
        {
            let insertables = newEntries.filter(canInsert)
            entries = (entries + insertables).sorted()
            return insertables.count
        }

        public init(groups: Set<Expression.Group>) {
            self.groups = groups
        }

        /// Initializes the `Page` using every `Entry` in `entries`, that is of
        /// the given `languages`, and in the given set of `groups`.
        public init <S: Sequence where S.Iterator.Element == Entry>(
            groups: Set<Expression.Group> = [],
            languages: (expressions: Language, translations: Language),
            entries: S
        ) {
            self.groups = groups
            self.entries = entries.filter { entry in
                entry.languages == languages &&
                groups.contains(entry.expression.group)
            }
        }
    }
}
