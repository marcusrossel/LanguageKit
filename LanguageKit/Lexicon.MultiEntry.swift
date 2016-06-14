//
//  Lexicon.MultiEntry.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 10.06.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//



/*
extension Lexicon {
    /// This is a pseudo-representation of what a `MultiEntry` works like:
    ///
    ///     expA   = Expression("live", Word, English)
    ///     expB/C = Expression("leben"/"wohnen", Word, German)
    ///
    ///     entry1 = Entry(expA, translations: [expB/C], context: "something")
    ///
    ///     expD   = Expression("bor", Word, Norwegian)
    ///     expE/F = Expression("reside"/"live", Word, English)
    ///
    ///     entry2 = Entry(expD, translations: [expE/F], context: "more stuff")
    ///
    ///     multiEntry = MultiEntry([entry1, entry2])
    ///
    /// The MultiEntry recognizes that `entry1` and `entry2` have an overlapping
    /// meaning as they both contain the same expression (`expA` and `expF`).
    /// Therefore both `Entry`s can be merged in a `MultiEntry`.
    ///
    /// The resulting `MultiEntry`s `pool` would look like this:
    ///
    ///     [(expA, "some context"),
    ///      (expB, "")            ,
    ///      (expC, "")            ,
    ///      (expD, "more context"),
    ///      (expE, "")]
    ///
    /// From this `pool` one can extract any possible configuration of `Entry`.
    /// For example one could supply the following criteria:
    ///
    ///     multiEntry.entriesWith(expression: German,
    ///                            groups: [Word],
    ///                            translations: Norwegian)
    ///
    /// And would get the following `Entry`s back:
    ///
    ///     Entry(expB, translations: [expD], context: "")
    ///     Entry(expC, translations: [expD], context: "")
    ///
    /// A `MultiEntry` therefore allows creating new combinations of `Entry`s
    /// implicitly, but only for `Expression`s with overlapping meaning.
    internal struct MultiEntry {
        private struct ContextualExpression {
            var value: (Expression, context: String)

            var expression: Expression {
                return value.0
            }

            var context: String {
                return value.context
            }
        }

        internal private(set) var pool = [(Expression, context: String)]() //make it a Set, order doesnt matter

        internal init() { }

        internal init(entry: Entry) {
            var newPool = [(entry.expression, context: entry.context)]
            newPool += entry.translations.map { expression in
                (expression, context: "")
            }
            pool = newPool
        }
    }
}*/
