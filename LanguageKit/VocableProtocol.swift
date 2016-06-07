//
//  VocableProtocol.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 23.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

/// A protocol representing types, that can be used as a vocable - supplying all
/// the functionality that entails.
public protocol VocableProtocol: Translatable {
    var style: AnyVocableType { get }

    /// Use this property to store additional information about a vocable.
    var context: [AnyLanguage: String] { get }

    /// `VocableProtocol`s should be able to produce `AnyTranslation`s, and be
    /// initialized by them.
    init(style: AnyVocableType, translation: AnyTranslation)
}

extension VocableProtocol {
    /// `VocableProtocol`'s `context` is somewhat optional.
    /// This default makes it easier to ignore.
    var context: [AnyLanguage: String] { return [:] }
}

@warn_unused_result
public func ==<T: VocableProtocol>(lhs: T, rhs: T) -> Bool {
    return lhs.contentPool == rhs.contentPool &&
           lhs.style       == rhs.style       &&
           lhs.context     == rhs.context
}