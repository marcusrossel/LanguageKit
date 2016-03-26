//
//  LKLanguage.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 23.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

import Foundation

/// Simple structure conforming to the base requirements of `LKLanguageType`.
///
/// All properties are implemented as constants, as this type is meant to be
/// used like a pure value.
public struct LKLanguage: LKLanguageType {
    public let description: String
}