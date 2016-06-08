//
//  VocableProtocol.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 07.06.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

public protocol VocableProtocol {
    var kind: String { get }

    var expressions: [Language: Expression] { get }
    var context: [Language: String] { get }

    var languages: Set<Language> { get }

    subscript(language: Language) -> Expression { get set }
    subscript(context language: Language) -> String { get set }
}