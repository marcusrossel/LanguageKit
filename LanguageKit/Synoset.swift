//
//  Synoset.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 11.06.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

/// An ordered set of `Expression`s of the same language, similar or equal in
/// meaning.
public struct Synoset {
  /// An ordered set of synonymous expressions.
  ///
  /// - Note: Although an `Array` is used, all `Expressions` are unique.
  public private(set) var synonyms: [Expression]

  /// The `Language` of the `Expressions` in `self`.
  public let language: Language

  /// Returns `true` if `expression` meets the conditions for being inserted
  /// into `synonyms`.
  internal func canInsert(_ expression: Expression) -> Bool {
    return expression.language == language && !synonyms.contains(expression)
  }

  /// Tries to inserts the given `Expression`.
  //
  /// - Precondition: The given `Expression` must be of the same `language`.
  ///
  /// - Returns: A `Bool` indicating whether insertion was successful.
  @discardableResult
  public mutating func insert(_ expression: Expression) -> Bool {
    guard canInsert(expression) else { return false }

    // Tries to find the correct `index` for `synonym` in `expressions`.
    let possibleIndex = synonyms.index { synonym -> Bool in
      expression < synonym
    }

    if let index = possibleIndex {
      synonyms.insert(expression, at: index)
    } else {
      // If `synonym` is "larger" than all other `Expression`s, it must be
      // appended.
      synonyms.append(expression)
    }

    return true
  }

  /// Removes the given `synonym` from `self`.
  ///
  /// - Returns: A `Bool` indicating whether `synonym` was even contained in
  /// `self`.
  @discardableResult
  public mutating func remove(_ synonym: Expression) -> Bool {
    // Tries to find the `index` of `synonym` in `synonyms`.
    if let index = synonyms.index(of: synonym) {
      synonyms.remove(at: index)
      return true
    } else {
      return false
    }
  }

  /// Discardes all `Expression`s in `expressions`, that are not of the given
  /// `language`.
  ///
  /// - Note:
  /// If `expressions` contains no `Expression`s of the given `language`,
  /// initialization fails.
  public init!<S: Sequence where S.Iterator.Element == Expression>(
    expressions: S,
    language: Language
  ) {
    self.language = language
    synonyms = expressions.sorted().filter { expression in
      expression.language == language
    }
  }

  /// Initializes `self` based on the `Language` of the first `Expression` in
  /// the given sequence.
  ///
  /// - Note:
  /// Based on the assumption that all `Expression`s are of the same language,
  /// this removes the need to explicitly supply the language.
  public init!<S: Sequence where S.Iterator.Element == Expression>(
    expressions: S
  ) {
    guard let firstExpression = Array(expressions).first else { return nil }
    self.init(expressions: expressions, language: firstExpression.language)
  }
}

/// Inserts all of the `Expression`s that share the `language` of the `synoset`
/// and are not already contained its `synonmys`.
public func +=<S: Sequence where S.Iterator.Element == Expression>(
    synoset: inout Synoset,
    expressions: S
) {
  let insertables = expressions.filter { expression -> Bool in
    synoset.canInsert(expression)
  }

  synoset.synonyms = (synoset.synonyms + insertables).sorted()
}

extension Synoset : Equatable { }
/// `Synoset`s are considered equal iff their `synonyms` are equal.
///
/// - Note:
/// The 'language' property doesn't have to be considered, as it is contained
/// within `synonyms` anyway.
public func ==(lhs: Synoset, rhs: Synoset) -> Bool {
  return lhs.synonyms == rhs.synonyms
}

extension Synoset : Collection {
  public typealias Index = Array<Expression>.Index
  public typealias SubSequence = Array<Expression>.SubSequence

  public var endIndex: Index {
    return synonyms.endIndex
  }

  public var startIndex: Index {
    return synonyms.startIndex
  }

  public func formIndex(after i: inout Index) {
    synonyms.formIndex(after: &i)
  }

  public func index(after i: Index) -> Index {
    return synonyms.index(after: i)
  }

  public subscript(position: Index) -> Expression {
    return synonyms[position]
  }

  public subscript(bounds: Range<Index>) -> SubSequence {
    return synonyms[bounds]
  }
}
