//
//  LKTranslatable.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 23.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

import Foundation

/// A protocol representing types, that have the ability to have
/// `LKTranslationType`s extracted from them.
public protocol LKTranslatable {
    var languageWordPool: [LKAnyLanguage: Set<String>] { get }
    subscript(original: LKAnyLanguage, derived: LKAnyLanguage) -> [LKAnyTranslation] { get }
}