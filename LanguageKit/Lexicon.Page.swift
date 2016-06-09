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
        public private(set) var groups = Set<Entry.Group>()

        /// This property stores the respective `Language`s of the expressions
        /// and translations of the `entries` for this `Page`.
        ///
        /// * Note: This property is duplicated in the `Entry`s themselves.
        public let languages: (expressions: Language, translations: Language)

        /// A sorted list storing all of the `Entry`s found on this `Page`.
        public private(set) var entries = [Entry]()

        /// A convenience method, to check if a given `Entry` satisfies all of
        /// the conditions needed, to be insertable into the `Page`'s `entires`.
        private func isInsertable(entry: Entry) -> Bool {
            return !entries.contains(entry) &&
                groups.contains(entry.group) &&
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
            guard isInsertable(newEntry) else { return false }

            for (index, entry) in entries.enumerate() {
                if newEntry.expression > entry.expression {
                    entries.insert(newEntry, atIndex: index)
                    return true
                }
            }
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
            let insertables = newEntries.filter { entry in isInsertable(entry) }

            entries += insertables
            entries.sortInPlace(<)
            
            return insertables.count
        }
    }
}