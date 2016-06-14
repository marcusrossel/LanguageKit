//
//  Lexicon.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 07.06.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

public struct Lexicon {
    private var storage = Set<Entry>()

    public func entries(from origin: Language, to destination: Language) -> [Entry] {
        // Gets all `Entry`s that can be returned as is.
        let finishedOnes1 = storage
            .filter { entry in entry.languages == (origin, destination) }

        // Gets all `Entry`s that contain the desired `Languages`, but flipped.
        // It then creates new `Entry`s by making the `translations`
        // `expression`s and vice versa.
        let finishedOnes2 = storage
            .filter  { entry in entry.languages == (destination, origin) }
            .map     { entry in entry.flipped }
            .flatMap { entry in entry }

        // Combines the `Entry`s that are returnable, and removes possible
        // duplicates, by storing them as a `Set`.
        let finishedOnes = Set(finishedOnes1 + finishedOnes2)

        // Gets all the `Entry`s, whose `expression`s are in the `Language` of
        // `origin`.
        let unfinishedOnes1 = storage.filter { entry in
            entry.expression.language == origin &&
            entry.translations.language != destination
        }

        // Gets all `Entry`s whose `translations` are in the `Language` of
        // `origin`.
        // It then creates new `Entry`s by making the `translations`
        // `expression`s and vice versa.
        let unfinishedOnes2 = storage
            .filter { entry in
                entry.expression.language != destination &&
                entry.translations.language == origin }
            .map     { entry in entry.flipped }
            .flatMap { entry in entry }

        // Combines the `Entry`s whose `expression` is in the `Language` of
        // `origin`, and removes possible duplicates, by storing them as a
        // `Set`.
        let unfinishedOnes = Set(unfinishedOnes1 + unfinishedOnes2)

        let unfinishedAndAssociates = storage.map { entry -> (Entry, [Entry]) in
            let associatedValues: [Entry] = storage.filter { ent in
                ent.expression == entry.expression ||
                ent.translations.contains(entry.expression)
            }

            return (entry, associatedValues)
        }

    }
}

// Method: (from: origin, to: destination)
//
// (1) filter storage for entries where languages.expression is origin
// (2) filter storage for entries where langauges.translation is origin
// (2.1) refactor those entires into multiple entries with flipped languages
// (2.2) for entires from 2.1 whose translations are not in the destination language, check if there exist entries (who also do not contain the origin language) with those expressions (the translations of incorrect language)
// (2.2.1) if any entries were found substitute the 2.1 entries' translations for the 2.2 entries' expressions of other language (if there's multiple 2.2 entries, merge the synonyms. if they're of other languages, make copies of the 2.1 entries)
// (2.2.1.1) goto (2.2) (process should stop when the destin. language is reached, if not build in stopping mechanism)
// (2.3) filter the 2.1 entries for the right languages
// (2.4) combine and return all entries


// E(hello - na, wie gehts)
// E(moin - hello, how ya doin, hey)
// E(tre - tree)
// E(baum - tre)
//
// (1)
// E(hello - na, wie gehts)
//
// (2)
// E(moin - hello, how ya doin, hey)
// E(tre - tree)
//
// (2.1)
// E(hello - moin)
// E(how ya doin - moin)
// E(hey - moin)
// E(tree - tre)
//
// (2.2)
// E(baum - tre)
//
// (2.2.1)
// E(tree - baum)
//
// (2.2.1.1)
// 
// (2.3)
//
// (2.4)

//
// English German
// German English -> English German
//
// Finished Ones
//

//
// English Some
// Some English -> English Some
//
// Unfinished Ones
//

// find those which have language Some and expression






