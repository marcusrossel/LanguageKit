//
//  Primitives.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 11.06.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

/// Represents the name of a language.
///
/// Could be used to allow differentiation of types used in association with it.
///
/// - Note:
/// A `Language` is to be used as a pure value, hence it is intrinsically
/// immutable.
public struct Language {
  /// The name/title of the `Language`.
  public let title: String

  /// Initializes an instance directly from the given `title`.
  ///
  /// - Parameter title:
  /// The name/title of the `Language`.
  ///
  /// - Note:
  /// Initialization fails if the `title` is an empty `String`.
  public init!(_ title: String) {
    // Precondition.
    guard !title.isEmpty else { return nil }

    self.title = title
  }
}

extension Language : Equatable {
  /// `Language`s are considered equal iff their `title`s are equal.
  public static func ==(lhs: Language, rhs: Language) -> Bool {
    return lhs.title == rhs.title
  }
}

extension Language : Hashable {
  public var hashValue: Int {
    return title.hashValue
  }
}

extension Language : Comparable {
  /// `Language`s compare by their `title`.
  public static func <(lhs: Language, rhs: Language) -> Bool {
    return lhs.title < rhs.title
  }
}

/*LEXICON-TEST-CODE-BEGIN*/
extension Language : CustomStringConvertible {
  public var description: String {
    return title
  }
}
/*LEXICON-TEST-CODE-END*/

/// A word or phrase of a certain group in a certain language.
public struct Expression {
  public let text: String
  public let group: Group
  public let language: Language
  public var context: String?

  /// Returns a new `Expression` with a changed value for `group`.
  ///
  /// - Parameter group:
  /// The `Expression.Group` which the new `Expression` should have.
  public func changing(group newGroup: Group) -> Expression {
    return Expression(text, in: language, group: newGroup, context: context)
  }

  /// Returns a new `Expression` with a changed value for `language`.
  ///
  /// - Parameter language:
  /// The `Language` which the new `Expression` should have.
  public func changing(language newLanguage: Language) -> Expression {
    return Expression(text, in: newLanguage, group: group, context: context)
  }

  /// Directly initializes all of `self`'s properties from their corresponding
  /// parameters.
  ///
  /// - Parameters:
  ///   - text: The actual expression as a `String`.
  ///   - language: The language in which the `text` is written.
  ///   - group: The group of expressions `text` belongs to.
  ///   - context: Optional context about the entire `Expression`.
  ///
  /// - Note:
  /// Initialization fails if the `text` is an empty `String`.
  public init!(
    _ text: String,
    in language: Language,
    group: Group,
    context: String? = nil
  ) {
    // Precondition.
    guard !text.isEmpty else { return nil }

    self.text     = text
    self.group    = group
    self.language = language
    self.context  = context
  }
}

extension Expression : Equatable {
  /// `Expression`s are considered equal iff all of their stored properties are
  /// equal.
  public static func ==(lhs: Expression, rhs: Expression) -> Bool {
    return lhs.text     == rhs.text     &&
           lhs.group    == rhs.group    &&
           lhs.language == rhs.language &&
           lhs.context  == rhs.context
  }
}

extension Expression : Hashable {
  public var hashValue: Int {
    // Removing the space would lead to more hash collisions.
    return "\(text) \(group) \(language) \(context)".hashValue
  }
}

extension Expression : Comparable {
  /// `Expression`s are compared on three levels:
  /// * If the `text`s differ, they will be compared.
  /// * If the `text`s do not differ, the `language`s will be compared.
  /// * If the `language`s do not differ either, the `group`s will be compared.
  public static func <(lhs: Expression, rhs: Expression) -> Bool {
    if lhs.text != rhs.text {
      return lhs.text < rhs.text
    } else if lhs.language != rhs.language {
      return lhs.language < rhs.language
    } else {
      return lhs.group < rhs.group
    }
  }
}

/*LEXICON-TEST-CODE-BEGIN*/
extension Expression : CustomStringConvertible {
  public var description: String {
    let contextString = context != nil ? ": \"\(context!)\"" : ""
    return "<\(language) \(group) \"\(text)\"\(contextString)>"
  }
}
/*LEXICON-TEST-CODE-END*/

extension Expression {
  /// Represents the name of a group/type of expressions.
  ///
  /// - Note:
  /// A `Group` is to be used as a pure value, hence it is intrinsically
  /// immutable.
  public struct Group {
    public let title: String

    /// Initializes an instance directly from the given `title`.
    ///
    /// - Note:
    /// Initialization fails if the `title` is an empty `String`.
    ///
    /// - Parameter title:
    /// The name/title of the `Group`.
    public init!(_ title: String) {
      // Precondition.
      guard !title.isEmpty else { return nil }

      self.title = title
    }
  }
}

extension Expression.Group : Equatable {
  /// `Expression.Group`s are considered equal iff their `title`s are equal.
  public static func ==(lhs: Expression.Group, rhs: Expression.Group) -> Bool {
    return lhs.title == rhs.title
  }
}

extension Expression.Group : Hashable {
  public var hashValue: Int {
    return title.hashValue
  }
}

extension Expression.Group : Comparable {
  /// `Expression.Group`s compare by their `title`.
  public static func <(lhs: Expression.Group, rhs: Expression.Group) -> Bool {
    return lhs.title < rhs.title
  }
}

/*LEXICON-TEST-CODE-BEGIN*/
extension Expression.Group : CustomStringConvertible {
  public var description: String {
    return title
  }
}
/*LEXICON-TEST-CODE-END*/
