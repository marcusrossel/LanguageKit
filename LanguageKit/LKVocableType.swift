//
//  VocableType.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 23.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

/// A protocol representing types, that can be used as a vocable - supplying all
/// the functionality that entails.
public protocol VocableType: Translatable {
    var style: AnyVocableStyle { get }

    /// Use this property to store additional information about a vocable.
    var context: [AnyLanguage: String] { get }

    /// `VocableType`s should be able to produce `AnyTranslation`s, and be
    /// initialized by them.
    init(style: AnyVocableStyle, translation: AnyTranslation)
}

extension VocableType {
    /// `VocableType`'s `context` is somewhat optional.
    /// This default makes it easier to ignore.
    var context: [AnyLanguage: String] { return [:] }
}

@warn_unused_result
public func ==<T: VocableType>(lhs: T, rhs: T) -> Bool {
    return lhs.languageWordPool == rhs.languageWordPool &&
           lhs.style            == rhs.style            &&
           lhs.context          == rhs.context
}