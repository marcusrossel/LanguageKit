//
//  LKTranslationType.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 20.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

public protocol LKTranslationType: Hashable {
    var languages: (original: LKAnyLanguage, derived: LKAnyLanguage) { get }
    var original: String { get }
    var derived: Set<String> { get }
    var context: String? { get }
}

public extension LKTranslationType {
    var context: String?  { return nil }

    /// Custom implemention of this property should be avoided, as it might
    /// cause disproportionate hash collisions.
    var hashValue: Int {
        let hashString = "\(languages)\(original)\(derived.sort())"
        return hashString.hashValue
    }
}

@warn_unused_result
public func ==<T: LKTranslationType>(lhs: T, rhs: T) -> Bool {
    return lhs.languages == rhs.languages &&
           lhs.original  == rhs.original  &&
           lhs.derived   == rhs.derived   &&
           lhs.context   == rhs.context
}
