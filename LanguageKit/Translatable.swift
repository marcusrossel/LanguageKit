//
//  Translatable.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 23.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

/// A protocol representing types, that have the ability to have
/// `TranslationType`s extracted from them.
public protocol Translatable {
    var languageWordPool: [AnyLanguage: Set<String>] { get }
    subscript(originalLanguage: AnyLanguage, derivedLanguage: AnyLanguage) -> [AnyTranslation] { get }
}