//
//  Vocable.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 07.06.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

public struct Vocable {
    public var kind: Kind

    private(set) public var expressions: [Language: Synonyms]
    private(set) public var context: [Language: String]

    public var languages: Set<Language> {
        return Set(expressions.keys)
    }

    public subscript(origin: Language, associated: Language) -> Set<Slice> {
        let originExpressions = expressions[origin] ?? []
        let associatedExpressions = expressions[associated] ?? []
        let sortedAssociatedExpressions = SortedSynonyms(associatedExpressions)
        let contexts = (context[origin] ?? "", context[associated] ?? "")

        let slices = originExpressions.map { (string) -> Slice in
            Slice(kind: kind,
                  expressions: (string, sortedAssociatedExpressions),
                  languages: (origin, associated),
                  contexts: contexts)
        }

        return Set(slices)
    }

    public subscript(language: Language) -> Synonyms {
        get { return expressions[language] ?? [] }
        set { expressions[language] = newValue }
    }

    public subscript(context language: Language) -> String {
        get {
            return context[language] ?? ""
        }
        set {
            guard languages.contains(language) else { return }
            context[language] = newValue
        }
    }

    public init?(kind: Kind, expressions: [Language: Synonyms], context: [Language: String] = [:]) {
        guard !kind.isEmpty && !expressions.isEmpty else { return nil }

        self.kind = kind
        self.expressions = expressions

        self.context = [:]
        let validLanguages = Set(expressions.keys)

        for (language, value) in context {
            if validLanguages.contains(language) {
                self.context[language] = value
            }
        }
    }
}

extension Vocable: Hashable {
    /// * TODO: Make the function body less ugly.
    public var hashValue: Int {
        let sortedExpressions = expressions.map { (language, expression) in
            return (language, expression.sort())
        }.sort { $0.0.0 < $0.1.0 }
        let sortedContext = context.sort { $0.0.0 < $0.1.0 }

        let hashString = "\(kind)\(languages.sort())\(sortedExpressions)\(sortedContext)"
        return hashString.hashValue
    }
}

public func ==(lhs: Vocable, rhs: Vocable) -> Bool {
    let equalKind = lhs.kind == rhs.kind
    let equalExpressions = lhs.expressions == rhs.expressions
    let equalContext = lhs.context == rhs.context

    return equalKind && equalExpressions && equalContext
}
