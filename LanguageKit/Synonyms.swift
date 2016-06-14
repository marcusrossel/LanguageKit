//
//  Synonyms.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 11.06.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

/// An ordered set of `Expression`s of the same language, similar or equal in
/// meaning.
public struct Synonyms {
  /// An ordered set of synonymous expressions.
  ///
  /// - Note: Although an `Array` is used, all `Expressions` are unique.
  public private(set) var synonyms: [Expression]

  /// The `Language` of the `Expressions` in `self`.
  public var language: Language {
    // `expressions` can never be empty, therefore `first` always exists.
    return synonyms.first!.language
  }

  /// Returns `true` if `expression` meets the conditions for being inserted
  /// into `synonyms`.
  internal func canInsert(_ expression: Expression) -> Bool {
    return expression.language == language && !synonyms.contains(expression)
  }

  /// Tries to inserts the given `Expression`.
  //
  /// - Precondition: The given `Expression` must be of the same language as
  /// the ones already contained in `self`.
  ///
  /// * Returns: A `Bool` indicating whether insertion was successful.
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

  /// Tries to remove the given `synonym` from `self`.
  ///
  /// - Precondition: `self` must hold at least two `Expression`s.
  ///
  /// * Returns: A `Bool` indicating whether removal was successful.
  @discardableResult
  public mutating func remove(_ synonym: Expression) -> Bool {
    guard synonyms.count > 1 else { return false }

    // Tries to find the `index` of `synonym` in `synonyms`.
    if let index = synonyms.index(of: synonym) {
      synonyms.remove(at: index)
      return true
    } else {
      return false
    }
  }

  /// Tries to swap the given `synonym` for a `newSynonym`.
  ///
  /// - Precondition: 
  ///   * `self` must contain `synonym`.
  ///   * If `self` holds more than one `Expression`, the new `expression` must
  ///     be of the same language as the old `synonym`.
  ///
  /// * Returns: A `Bool` indicating whether the swap was successful.
  @discardableResult
  public mutating func swap(_ synonym: Expression, for expression: Expression) -> Bool {
    guard synonyms.contains(synonym) else { return false }

    if synonyms.count == 1 {
      synonyms[synonyms.startIndex] = expression
    } else {
      if expression.language == language {
        if let index = synonyms.index(of: synonym) {
          synonyms[index] = expression
        }
      }
    }

    return true
  }

  /// Discardes all `Expression`s in `expressions`, that are not of the given
  /// `language`.
  ///
  /// - Note: If `expressions` contains no `Expression`s of the given
  /// `language`, initialization fails.
  public init!<S: Sequence where S.Iterator.Element == Expression>(
    expressions: S,
    language: Language
  ) {
    synonyms = expressions.sorted().filter { expression in
      expression.language == language
    }
  }
}

/// Inserts all of the `Expression`s that share the `language` of the `target`
/// and are not already contained in these `Synonmys`.
public func +=<S: Sequence where S.Iterator.Element == Expression>(
    target: inout Synonyms,
    expressions: S
) {
  let insertables = expressions.filter { expression -> Bool in
    target.canInsert(expression)
  }

  target.synonyms = (target.synonyms + insertables).sorted()
}

extension Synonyms : Equatable { }
/// `Synonyms` are considered equal iff their `synonyms` are equal.
public func ==(lhs: Synonyms, rhs: Synonyms) -> Bool {
  return lhs.synonyms == rhs.synonyms
}

extension Synonyms : Collection {
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
