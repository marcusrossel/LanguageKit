//
//  LKVocableType.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 23.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

/// A protocol representing types, that can be used as a vocable - supplying all
/// the functionality that entails.
public protocol LKVocableType: LKTranslatable {
    var style: LKAnyVocableStyle { get }

    /// Use this property to store additional information about a vocable.
    var context: [LKAnyLanguage: String] { get }
}

extension LKVocableType {
    /// `LKVocableType`'s `context` is somewhat optional.
    /// This default makes it easier to ignore.
    var context: [LKAnyLanguage: String] { return [:] }
}

@warn_unused_result
public func ==<T: LKVocableType>(lhs: T, rhs: T) -> Bool {
    return lhs.languageWordPool == rhs.languageWordPool &&
           lhs.style            == rhs.style            &&
           lhs.context          == rhs.context
}