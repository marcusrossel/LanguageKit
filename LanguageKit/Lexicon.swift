//
//  Lexicon.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 07.06.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

public struct Lexicon {
  private var storage = Set<Entry>()

  public init(entries: [Entry]) {
    storage = Set(entries)
  }

  public func entries(origin: Language, destination: Language) -> [String: Any] {
    let desiredLanguages = (origin, destination)

    // Gets all `Entry`s that can be returned as is.
    let completeEntries1 = storage.filter { $0.languages == desiredLanguages }

    // Gets all `Entry`s that contain the desired `Languages`, but flipped,
    // and flipps them.
    let completeEntries2 = storage
      .filter { $0.languages == (destination, origin) }
      .map { $0.flipped() }
      .flatMap { $0 }

    // Combines the `Entry`s that are returnable, and removes possible
    // duplicates, by storing them as a `Set`.
    let completeEntries = completeEntries1 + completeEntries2

    // Gets all the `Entry`s, whose `expression`s are in the `Language` of
    // `origin`.
    let incompleteEntries1 = storage.filter { entry in
      entry.title.language == origin &&
        entry.translations.language != destination
    }

    // Gets all `Entry`s whose `translations` are in the `Language` of
    // `origin` and flipps them.
    let incompleteEntries2 = storage
      .filter { entry in
        entry.title.language != destination &&
          entry.translations.language == origin
      }
      .map { $0.flipped() }
      .flatMap { $0 }

    // Combines the `Entry`s whose `expression` is in the `Language` of
    // `origin`, and removes possible duplicates.
    let incompleteEntries = Array(Set(incompleteEntries1 + incompleteEntries2))

    // Split every Entry in incompleteEntries up into Expression pairs,
    // turning them back into Entrys after transformation, while unifying the
    // pairs with the same `title` Expression.
    let expressionsPairs = incompleteEntries.map {
      entry -> [(Expression, Expression)] in
      entry.translations.map { (entry.title, $0) }
      }.flatMap { $0 }


    // allow more than one layer depth, but then watch out that no link-cycles spawn
    let enhancedPairs = expressionsPairs.map { (title, translation) -> [(Expression, Expression)] in
      let associatedEntries: [Entry] = storage.filter { entry in
        entry.title.language != origin &&
          entry.translations.language != origin &&
          entry.containsAnyOf([translation])
      }

      let associatedExpressions = associatedEntries.map { associate -> [Expression] in
        if associate.title == translation {
          return Array(associate.translations)
        } else /*associate.translations.contains(translation)*/ {
          return [associate.title]
        }
        }.flatMap { $0 }

      return associatedExpressions.map { (title, $0) }
      }.flatMap { $0 }

    // translations that could not be enhanced further, but never endet up being of the desired language are removed
    let validPairs = enhancedPairs.filter { (_, translation) in
      translation.language == destination
    }

    var expressionStructurePairs = [(Expression, Synoset)]()

    for pair in validPairs {
      if let index = (expressionStructurePairs.index { (title, _) in title == pair.0 }) {
        expressionStructurePairs[index].1.insert(pair.1)
      } else {
        expressionStructurePairs.append((pair.0, Synoset(expression: pair.1)))
      }
    }

    let enhancedEntries = expressionStructurePairs.map { (expression, synoset) -> Entry in
      Entry(title: expression, translations: synoset)
    }

    let finalResult = completeEntries + enhancedEntries

    return ["completeEntries": completeEntries,
            "incompleteEntries": incompleteEntries,
            "expressionPairs": expressionsPairs,
            "enhancedPairs": enhancedPairs,
            "expressionStructurePairs": expressionStructurePairs,
            "enhancedEntries": enhancedEntries,
            "finalResult": finalResult]
  }
}
