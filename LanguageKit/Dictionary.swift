//
//  Dictionary.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 26.03.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

extension Dictionary {
    /// This method maps the keys of a dictionary to new keys, associating them
    /// with the same values as before though.
    func mapKeys<NewKey: Hashable>(@noescape transform: (Key) throws -> NewKey) rethrows -> [NewKey: Value] {
        let bothKeys = try keys.map { key in
            return (key, try transform(key))
        }

        var newDictionary: [NewKey: Value] = [:]
        for (oldKey, newKey) in bothKeys {
            newDictionary[newKey] = self[oldKey]
        }

        return newDictionary
    }
}