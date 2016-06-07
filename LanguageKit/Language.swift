//
//  Language.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 23.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

/// Simple structure conforming to the base requirements of `LanguageProtocol`.
///
/// All properties are implemented as constants, as this type is meant to be
/// used like a pure value.
public struct Language: LanguageProtocol {
    public let identifier: String
}