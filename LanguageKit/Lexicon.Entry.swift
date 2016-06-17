//
//  Lexicon.Entry.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 09.06.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

extension Lexicon {
  /// Represents the thing you would find when looking up an expression in a
  /// dictionary.
  ///
  /// It consists of:
  /// * an `expression`, by which one would usually find an entry.
  /// * multiple `translations` of the `expression` in a different language.
  ///
  /// - Note:
  /// Once an `Entry` is initialized you can not change its `expression`, as
  /// this property is fundametal to an `Entry`. If this behavior is desired,
  /// one should consider creating a new `Entry`.
  ///
  /// An `Entry`'s `translations` can be modified, but will have the same
  /// `Language` across the entire lifetime of an `Entry`.
  ///
  /// Therefore an `Entry` does not store its `Language`s explicitly, but
  /// rather implicitly in its `expression` and `translations`. This method is
  /// viable, as these properties can never change their `Language` once set.
  public struct Entry {
    public let title: Expression
    public private(set) var translations: Synoset

    /*LEXICON-TEST-CODE-BEGIN*/
    internal var languages: (Language, Language) {
      return (title.language, translations.language)
    }

    internal func contains(_ expression: Expression) -> Bool {
      return title == expression || translations.contains(expression)
    }
    /*LEXICON-TEST-CODE-END*/

    /// Returns a set of *flipped* `Entry`s.
    ///
    /// An `Entry` is *flipped*, by changing its `title` and `translations`. As
    /// there can be multiple `translations`, a flip can produce multiple
    /// `Entry`s.
    ///
    /// - Note:
    /// An empty set is returned if `translations` is empty.
    ///
    /// This method is optimized for the case that `translations` is empty.
    public func flipped() -> Set<Entry> {
      // Optimizations.
      guard !translations.isEmpty else { return [] }

      let titleSynoset = Synoset(expression: title)
      let flippedEntries = translations.map {
        Entry(title: $0, translations: titleSynoset)
      }

      return Set(flippedEntries)
    }

    /// Inserts the given `expression` into the `translations` `Synoset`.
    ///
    /// - Returns:
    /// A `Bool` indicating if insertion was successful.
    ///
    /// - Note:
    /// Insertion will only be successful if the `expression`'s language equals
    /// the `translations`' language.
    public mutating func insert(expression: Expression) -> Bool {
      return translations.insert(expression)
    }

    /// Removes the given `translation` from `translations`.
    public mutating func remove(translation: Expression) {
      translations.remove(translation)
    }

    public init(title: Expression, translations: Synoset) {
      self.title = title
      self.translations = translations
    }
  }
}

/// Tries to insert the given `Expression`s into `entry`s `translations`.
///
/// - Note:
/// Only `Expression`s whose language equals the `entry`'s `translations`'
/// language will be insertable.
///
/// This function is optimized for the case that either parameter's sequence is
/// empty, that the languages do not match, and that `expression` is of type
/// `Synoset`.
public func +=<S: Sequence where S.Iterator.Element == Expression>(
  entry: inout Lexicon.Entry,
  expressions: S
  ) {
  // Optimization is performed by the `+=` operator.
  entry.translations += expressions
}

extension Lexicon.Entry : Equatable { }
/// `Lexicon.Entry`s are considered equal iff all of their stored properties
/// are equal.
public func ==(lhs: Lexicon.Entry, rhs: Lexicon.Entry) -> Bool {
  return lhs.title        == rhs.title &&
         lhs.translations == rhs.translations
}

extension Lexicon.Entry : Hashable {
  public var hashValue: Int {
    let strings = [title.text] + translations.map { $0.text }
    return "\(strings)".hashValue
  }
}

extension Lexicon.Entry : Comparable { }
/// `Lexicon.Entry`s are compared by their `title` property.
public func <(lhs: Lexicon.Entry, rhs: Lexicon.Entry) -> Bool {
  return lhs.title < rhs.title
}

/*LEXICON-TEST-CODE-BEGIN*/
extension Lexicon.Entry : CustomStringConvertible {
  public var description: String {
    return "Entry(\(title): \(translations))"
  }
}
/*LEXICON-TEST-CODE-END*/
