//
//  Vocable.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 07.06.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

public struct Vocable: VocableProtocol {
    public typealias Kind = String

    public var kind: Kind

    private(set) public var expressions: [Language: Expression]
    private(set) public var context: [Language: String]

    public var languages: Set<Language> {
        return Set(expressions.keys)
    }

    public subscript(language: Language) -> Expression {
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

    public init?(kind: Kind, expressions: [Language: Expression], context: [Language: String] = [:]) {
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