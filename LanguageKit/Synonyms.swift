//
//  Synonyms.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 11.06.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

/// An ordered set of `Expression`s of the same `Language`, similar or equal in
/// meaning.
public struct Synonyms {
    public private(set) var expressions = [Expression]()
    public let language: Language

    /// Inserts the given `Expression`, if it is of the required `Language` and
    /// not already contained in these `Synonmys`.
    ///
    /// * Returns: A `Bool` indicating if insertion was successful.
    public mutating func insert(newExpression: Expression) -> Bool {
        guard newExpression.language == language &&
              !expressions.contains(newExpression)
        else { return false }

        for (index, expression) in expressions.enumerate() {
            if newExpression < expression {
                expressions.insert(newExpression, atIndex: index)
                return true
            }
        }

        expressions.append(newExpression)
        return true
    }

    public mutating func remove(expression: Expression) {
        guard let index = expressions.indexOf(expression) else { return }
        expressions.removeAtIndex(index)
    }

    public init(language: Language) {
        self.language = language
    }

    /// This initializer discardes all `Expression`s in `expressions`, that are
    /// not of the given `language`.
    public init<S: SequenceType where S.Generator.Element == Expression>(
        expressions: S,
        language: Language
    ) {
        self.init(language: language)
        self.expressions = expressions.sort().filter { expression in
            expression.language == language
        }
    }
}

/// Inserts all of the `Expression`s, that share the `Language` of target and
/// are not already contained in these `Synonmys`.
public func +=<S: SequenceType where S.Generator.Element == Expression>(
    inout synonyms: Synonyms,
    expressions: S
) {
    let uniqueExpressions = Set(synonyms.expressions + expressions)
    let relevantExpressions = uniqueExpressions.filter { expression in
        expression.language == synonyms.language
    }

    synonyms.expressions = relevantExpressions.sort()
}

public func -=<S: SequenceType where S.Generator.Element == Expression>(
    inout synonyms: Synonyms,
    expressions: S
) {
    synonyms.expressions = synonyms.expressions.filter { expression in
        !expressions.contains(expression)
    }
}

extension Synonyms: Equatable { }
/// `Synonyms` are considered equal, if both of their stored properties
/// evaluate as equal.
public func ==(lhs: Synonyms, rhs: Synonyms) -> Bool {
    return lhs.expressions == rhs.expressions && lhs.language == rhs.language
}

extension Synonyms: CollectionType {
    public typealias Index = Array<Expression>.Index

    public var startIndex: Index {
        return expressions.startIndex
    }

    public var endIndex: Index {
        return expressions.endIndex
    }

    public subscript(position: Index) -> Expression {
        return expressions[position]
    }
}
