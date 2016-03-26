//
//  LKTranslatable.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 23.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

import Foundation

public protocol LKTranslatable {
    var translations: [LKAnyLanguage: Set<String>] { get set }
}