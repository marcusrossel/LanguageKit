//
//  LKTranslation.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 23.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

import Foundation

/// Simple structure conforming to the base requirements of `LKTranslationType`.
///
/// All properties are implemented as constants, as this type is meant to
/// be used like a pure value.
public struct LKTranslation: LKTranslationType {
    public let languages: (original: LKAnyLanguage, translations: LKAnyLanguage)
    public let original: String
    public let translations: Set<String>
    public let context: String?
}