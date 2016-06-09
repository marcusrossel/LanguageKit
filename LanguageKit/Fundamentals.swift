//
//  Fundamentals.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 07.06.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

/// A word or phrase.
public typealias Expression = String

/// A set of expressions similar or equal in meaning.
///
/// * Warning: In the context of *LanguageKit* `Synonyms` should not be
/// used for `Expression`s of multiple languages.
///
///       // Used as intended:
///       let greeting: Synonyms = ["Hello", "Hi", "Hey"]
///
///       // Used across multiple languages (not used as intended):
///       let greeting: Synonyms = ["Hello", "Hallo", "Hei", "Olá"]
public typealias Synonyms = Set<Expression>

/// A sorted version of `Synonyms`.
///
/// The `Expression`s in this data structure are not inherently sorted, but are
/// rather promised to be by users of this type.
public typealias SortedSynonyms = [Expression]

/// A `Language` is simply supposed to represent the name of a language, in
/// order to allow differentiation of types used in association with it (e.g.
/// expressions).
public typealias Language = String

