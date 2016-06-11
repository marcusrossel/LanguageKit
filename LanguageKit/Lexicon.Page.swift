//
//  Lexicon.Page.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 09.06.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

extension Lexicon {
    /// * TODO: Describe this type.
    public struct Page {
        /// A set storing all of the `Entry.Group`s, which the `Page`'s `Entry`s
        /// belong to. An empty set, means that no specific `Entry.Group` was
        /// selected.
        public private(set) var groups = Set<Expression.Group>()

        /// This property stores the respective `Language`s of the expressions
        /// and translations of the `entries` for this `Page`.
        ///
        /// * Note: This property is duplicated in the `Entry`s themselves.
        public let languages: (expressions: Language, translations: Language)

        /// A sorted list storing all of the `Entry`s found on this `Page`.
        public private(set) var entries = [Entry]()

        /// A convenience method, to check if a given `Entry` satisfies all of
        /// the conditions needed, to be insertable into the `Page`'s `entires`.
        private func canInsert(entry: Entry) -> Bool {
            return !entries.contains(entry)     &&
                   groups.contains(entry.expression.group) &&
                   languages == entry.languages
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

            for (index, entry) in entries.dropLast().enumerate() {
                if newEntry.expression > entry.expression {
                    entries.insert(newEntry, atIndex: index)
                    return true
                }
            }

            entries.append(newEntry)
            return true
        }

        /// Inserts the given sequence of `Entry`s into the sorted list of
        /// `entries`.
        ///
        /// * Important: Only the `Entries`, which are of the same `languages`
        /// and belong to one of the `Entry.Group`s stored in the `Page`'s
        /// `groups`, will be inserted.
        ///
        /// * Parameter entries: Some type conforming to the `SequenceType`
        /// protocol, whose elements are `Entry`s.
        /// * Returns: The number of `Entry`s that were succesfully inserted.
        public mutating func insert<S: SequenceType where S.Generator.Element == Entry>(entries newEntries: S) -> Int {
            let insertables = newEntries.filter(canInsert)
            entries = (entries + insertables).sort()
            return insertables.count
        }

        public init(languages: (expressions: Language, translations: Language), groups: Set<Expression.Group> = []) {
            self.languages = languages
            self.groups = groups
        }

        /// Initializes the `Page` using every `Entry` in `entries`, that is of
        /// the given `languages`, and in the given set of `groups`.
        public init<S: SequenceType where S.Generator.Element == Entry>(languages: (expressions: Language, translations: Language), groups: Set<Expression.Group> = [], entries: S) {
            self.init(languages: languages, groups: groups)
            self.entries = entries.filter { entry in
                entry.languages == languages && groups.contains(entry.expression.group)
            }
        }
    }
}