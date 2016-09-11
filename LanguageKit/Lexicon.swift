//
//  Lexicon.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 07.06.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

// A structure that holds a set of `Entry`s and gives means of working with them
// efficiently.
public struct Lexicon {
  private var storage = Set<Entry>()

  /// Acts like `filter` on `set`, but returns the included elements and removes
  /// them from `set`.
  ///
  /// - Parameters:
  ///   - set: The set of `Entry`s off of which some `Entry`s are carved.
  ///   - carveEntry: Indicates if an `Entry` should be carved off of `set`.
  ///
  /// - Returns:
  /// A set of `Entry`s which met the condition to `carveEntry`.
  private func carvingOff(of set: inout Set<Entry>, carveEntry: (Entry) -> Bool)
  -> Set<Entry> {
    let returnValue = Set(set.filter(carveEntry))
    set.subtract(returnValue)
    return returnValue
  }

  /// Returns all entries constructable that are of the given languages.
  /// These entries are in part taken as is from the `Lexicon`'s storage, the
  /// rest is constructed by connecting expressions of equal meaning across
  /// languages.
  ///
  /// - Returns:
  /// A sorted array of unique `Entry`s, whose `languages` are the given ones.
  public func entries(
    title titleLanguage: Language,
    translations translationsLanguage: Language
  ) -> [Entry] {
    var remainingEntries = storage

    // Gets all `Entry`s that can be returned as is.
    let completeEntries1 = carvingOff(of: &remainingEntries) {
      $0.languages == (titleLanguage, translationsLanguage)
    }

    // Gets all `Entry`s that contain the desired languages but flipped, and
    // flipps them.
    let completeEntries2 = carvingOff(of: &remainingEntries) {
      $0.languages == (translationsLanguage, titleLanguage)
      }
      .map { $0.flipped() }
      .flatMap { $0 }

    // Combines the `Entry`s that are returnable as is.
    let completeEntries = completeEntries1 + completeEntries2

    // Gets all the `Entry`s, whose `title`s are in the language of `origin`
    // (the `translations`' language can't be `destination`, as those `Entry`s
    // have been carved off before).
    let incompleteEntries1 = carvingOff(of: &remainingEntries) {
      $0.title.language == titleLanguage
    }

    // Gets all the `Entry`s, whose `translations` are in the language of
    // `origin` (the `title`'s language can't be `destination`, as those
    // `Entry`s have been carved off before).
    let incompleteEntries2 = carvingOff(of: &remainingEntries) {
      $0.translations.language == titleLanguage
      }
      .map { $0.flipped() }
      .flatMap { $0 }

    // Combines the `Entry`s that are not completely processed yet.
    let incompleteEntries = incompleteEntries1 + incompleteEntries2

    // A `ProcessingPair` is a pair of `Expression`s with some meta-data.
    typealias ProcessingPair = (title: Expression,
      translation: Expression,
      isFullyProcessed: Bool,
      usedEntries: Set<Entry>)

    // Split every `Entry` in `incompleteEntries` into pairs of `Expression`s.
    // Therefore one `Entry` produces as many pairs as it has `translations`.
    // The additional fields in the tuple will be used in following code.
    var processingPairs: [ProcessingPair] = incompleteEntries
      .map { entry in entry.translations.map { (entry.title, $0, false, []) } }
      .flatMap { $0 }

    // Processes each pair in `processingPairs` until each one
    // `isFullyProcessed`, while removing those, which will never be fully
    // processed.
    while processingPairs.contains(where: { !$0.isFullyProcessed }) {
      processingPairs = processingPairs.map { pair -> [ProcessingPair] in
        // Returns every `pair` that `isFullyProcessed` as is.
        guard !pair.isFullyProcessed else { return [pair] }

        // Gets all `remainingEntries` that contain the `pair`'s `translation`
        // and have not been associated/used with this `pair` before.
        let associatedEntries = remainingEntries.filter {
          !pair.usedEntries.contains($0) && $0.contains(pair.translation)
        }

        // Removes `pair`s that will never be fully processed (branches by which
        // the `destination` language never will be reached).
        //
        // Alternative: [(pair.title, pair.translation, true, pair.usedEntries)]
        // ... with later filtering of those pairs (wrong translation language).
        guard !associatedEntries.isEmpty else { return [] }

        // Gets all the `Expression`s that `pair.translation` translates to from
        // the `associatedEntries`.
        let associatedExpressions = associatedEntries.map {
          entry -> [Expression] in
          if entry.title == pair.translation {
            return Array(entry.translations)
          } else {
            return [entry.title]
          }
          }
          .flatMap { $0 }

        // Creates and returns the `ProcessingPair`s, while using the
        // `associatedExpressions` as `translation` values.
        return associatedExpressions.map {
          let isFullyProcessed = $0.language == translationsLanguage
          let usedEntries = pair.usedEntries.union(associatedEntries)
          return (pair.title, $0, isFullyProcessed, usedEntries)
        }
        }
        .flatMap { $0 }
    }

    // Maps the `processingPairs` back to normal `Expression` pairs.
    let processedPairs = processingPairs.map { ($0.title, $0.translation) }

    /*ENHANCE-THIS-ALGORITHM-BEGIN*/
    var processedEntries = [Entry]()

    for pair in processedPairs {
      if let index = (processedEntries.index {  $0.title == pair.0 }) {
        processedEntries[index].insert(expression: pair.1)
      } else {
        let translations = Synoset(expression: pair.1)
        let entry = Entry(title: pair.0, translations: translations)
        processedEntries.append(entry)
      }
    }
    /*ENHANCE-THIS-ALGORITHM-END*/

    return (completeEntries + processedEntries).sorted()
  }

  public init() { }

  public init(entry: Entry) {
    storage = [entry]
  }

  public init(entries: [Entry]) {
    storage = Set(entries)
  }
}
