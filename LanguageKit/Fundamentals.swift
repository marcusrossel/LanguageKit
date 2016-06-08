//
//  Fundamentals.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 07.06.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

/// A set of words/phrases/etc. of the same meaning.
///
/// - Warning: In the context of *LanguageKit* an `Expression` should not be
/// used for words/phrases/etc. of multiple languages.
///
///       // Used as intended:
///       let greeting: Expression = ["Hello", "Hi", "Hey"]
///
///       // Used across multiple languages:
///       let greeting: Expression = ["Hello", "Hallo", "Hei", "Olá"]
public typealias Expression = Set<String>

public typealias Language = String