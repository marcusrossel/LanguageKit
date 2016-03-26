//
//  LKVocableType.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 23.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

import Foundation

public protocol LKVocableType: LKTranslatable {
    var style: LKAnyVocableStyle { get set }
    var context: [LKAnyLanguage: String] { get set }
}

extension LKVocableType {
    var context: [LKAnyLanguage: String] { return [:] }
}