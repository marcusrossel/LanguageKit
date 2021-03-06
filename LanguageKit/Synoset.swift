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
  /// - Note:
  /// Although an `Array` is used, all `Expressions` are unique.
  public fileprivate(set) var synonyms = [Expression]()

  /// The `Language` of the `Expressions` in `self`.
  public let language: Language

  /// Tries to inserts the given `Expression`.
  ///
  /// - Returns:
  /// A `Bool` indicating whether insertion was successful (an insertion also
  /// counts as successful if the given `Expression` was already contained in
  /// `synonyms`).
  ///
  /// - Precondition:
  /// The given `Expression` must be of the same `language`.
  ///
  /// - Note:
  /// This method is optimized for the case that `synonyms` is empty.
  @discardableResult
  public mutating func insert(_ expression: Expression) -> Bool {
    // Precondition.
    guard expression.language == language else { return false }

    // Optimizations.
    guard !synonyms.isEmpty else {
      synonyms = [expression]
      return true
    }
    guard !synonyms.contains(expression) else { return true }

    // Tries to find the correct `index` for `expression` in `synonyms`.
    let possibleIndex = synonyms.index { synonym in synonym > expression }

    if let index = possibleIndex {
      synonyms.insert(expression, at: index)
    } else {
      // If `expression` is greater than all other `Expression`s, it must be
      // appended.
      synonyms.append(expression)
    }

    return true
  }

  /// Merges two sorted arrays of unique `Expression`s while removing
  /// duplicates.
  ///
  /// - Parameter optimized:
  /// A `Bool` indicating wheter the method should optimize for empty arrays.
  /// Using this option only makes sense, if one has not checked for empty
  /// arrays before calling this method.
  ///
  /// - Precondition:
  /// Both arrays are sorted and only contain unique elements within themselves.
  ///
  /// - Warning:
  /// The result will still be valid if the `Expression`s are of different
  /// languages.
  ///
  /// - Note:
  /// This method is optimized for the case that either array is empty.
  private func mergeUnique(
    _ lhs: [Expression],
    _ rhs: [Expression],
    optimized: Bool = true
  ) -> [Expression] {
    // Shortcuts on empty arrays if `optimized` is `true`.
    if optimized && (lhs.isEmpty || rhs.isEmpty) {
      return lhs.isEmpty ? rhs : lhs
    }

    // Variable shadows of the function parameters.
    var left = lhs
    var right = rhs

    var returnArray = [Expression]()

    while !left.isEmpty && !right.isEmpty {
      // Force-unwrapping is safe, as `left` and `right` have just been checked
      // not to be empty, and therefore have a `first` element.
      let firstOfLeft = left.first!
      let firstOfRight = right.first!

      if firstOfLeft == firstOfRight {
        // Removes duplicates.
        left.removeFirst()
      } else if firstOfLeft < firstOfRight {
        returnArray.append(left.removeFirst())
      } else {
        returnArray.append(right.removeFirst())
      }
    }

    // Appends possible remaining values of `left`/`right` onto `returnArray`.
    returnArray += left.isEmpty ? right : left

    return returnArray
  }

  /// Merges `self` with another `Synoset`.
  ///
  /// - Returns:
  /// A `Bool` indicating whether the merge was successful.
  ///
  /// - Precondition:
  /// The `Synosets` must have the same `language`.
  ///
  /// - Note:
  /// This method is optimized for the case that `synoset` or `self` is empty.
  @discardableResult
  public mutating func merge(with synoset: Synoset) -> Bool {
    // Precondition.
    guard synoset.language == language else { return false }

    // Optimizations.
    guard !synoset.synonyms.isEmpty else { return true }
    guard !synonyms.isEmpty else {
      synonyms = synoset.synonyms
      return true
    }

    // `optimized` is `false`, as it would be redundant in this case.
    synonyms = mergeUnique(synonyms, synoset.synonyms, optimized: false)
    return true
  }

  /// Returns the result of trying to merge `self` and another `Synoset`.
  ///
  /// - Returns:
  /// The merged `Synoset`, or `nil` of they could not be merged.
  ///
  /// - Precondition:
  /// The `Synosets` must have the same `language`.
  ///
  /// - Note:
  /// This method is optimized for the case that `synoset` is empty.
  public func merging(_ synoset: Synoset) -> Synoset? {
    guard synoset.language == language else { return nil }

    // Optimizations.
    guard !synoset.synonyms.isEmpty else { return self }
    guard !synonyms.isEmpty else { return synoset }

    // Creates an empty `Synoset` and directly assigns the merge's result to its
    // `synonyms` (a little more complicated, but more efficient).
    var returnValue = Synoset(language: language)
    // `optimized` is `false`, as it would be redundant in this case.
    returnValue.synonyms = mergeUnique(synonyms,
                                       synoset.synonyms,
                                       optimized: false)
    return returnValue
  }

  /// Removes the given `synonym` from `self`.
  ///
  /// - Returns:
  /// A `Bool` indicating whether `synonym` was even contained in `self`.
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

  /// Removes all `Expression`s in `self`.
  ///
  /// - Returns:
  /// A copy of `synonyms` before it's clearing.
  @discardableResult
  public mutating func removeAll() -> [Expression] {
    defer { synonyms.removeAll() }
    return synonyms
  }

  /// Initializes an empty `Synoset` with a fixed `language`.
  public init(language: Language) {
    self.language = language
  }

  /// Initializes a `Synoset` from one `Expression`.
  public init(expression: Expression) {
    self.init(language: expression.language)
    synonyms = [expression]
  }

  /// Discardes all `Expression`s in `expressions`, that are not of the given
  /// `language`.
  public init<S: Sequence>(expressions: S, language: Language) where
    S.Iterator.Element == Expression
  {
    self.init(language: language)
    synonyms = expressions.filter { $0.language == language }.sorted()
  }

  /// Initializes `self` based on the `Language` of the first `Expression` in
  /// the given sequence.
  ///
  /// - Note:
  /// Based on the assumption that all `Expression`s are of the same language,
  /// this removes the need to explicitly supply the language.
  public init!<S: Sequence>(expressions: S) where
    S.Iterator.Element == Expression
  {
    guard let firstExpression = Array(expressions).first else { return nil }
    self.init(expressions: expressions, language: firstExpression.language)
  }
}

/// Inserts all of the `Expression`s that share the `language` of the `synoset`
/// and are not already contained its `synonmys`.
///
/// - Note:
/// This function is optimized for the case that either parameter's sequence is
/// empty, that the languages do not match, and that `expression` is of type
/// `Synoset`.
public func +=<S: Sequence>(synoset: inout Synoset, expressions: S) where
  S.Iterator.Element == Expression
{
  // Differentiates between several cases of certain arrays being empty, or
  // the passed sequence being of type `Synoset`, etc. for efficiency.
  switch (expressions as? Synoset, synoset.synonyms.isEmpty) {
  case (let derived?, true)
    where !derived.synonyms.isEmpty && derived.language == synoset.language:
    synoset.synonyms = derived.synonyms
  case (let derived?, false)
    where !derived.synonyms.isEmpty && derived.language == synoset.language:
    synoset.merge(with: derived)
  case (nil, let synosetIsEmpty) where !Array(expressions).isEmpty:
    let languageCompliants = expressions.filter {
      $0.language == synoset.language
    }
    let insertables = Set(languageCompliants)

    if synosetIsEmpty {
      synoset.synonyms = insertables.sorted()
    } else {
      synoset.synonyms = (synoset.synonyms + insertables).sorted()
    }
  default:
    return
  }
}

extension Synoset : Equatable {
  /// `Synoset`s are considered equal iff their `synonyms` are equal.
  ///
  /// - Note:
  /// The 'language' property doesn't have to be considered, but is used as a
  /// possible shortcut for determining inequality.
  public static func ==(lhs: Synoset, rhs: Synoset) -> Bool {
    return lhs.language == rhs.language && lhs.synonyms == rhs.synonyms
  }
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

/*LEXICON-TEST-CODE-BEGIN*/
extension Synoset : CustomStringConvertible {
  public var description: String {
    return "\(synonyms)"
  }
}
/*LEXICON-TEST-CODE-END*/
