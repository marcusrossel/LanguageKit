//
//  LKTranslatable.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 23.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

/// A protocol representing types, that have the ability to have
/// `LKTranslationType`s extracted from them.
public protocol LKTranslatable {
    var languageWordPool: [LKAnyLanguage: Set<String>] { get }
    subscript(originalLanguage: LKAnyLanguage, derivedLanguage: LKAnyLanguage) -> [LKAnyTranslation] { get }
}