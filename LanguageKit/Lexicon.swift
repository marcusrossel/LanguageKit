//
//  Lexicon.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 07.06.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

struct _Lexicon<V: VocableProtocol where V: Hashable> {
    private var storage = Set<V>()

    public subscript(kind: Vocable.Kind, original: Language, derived: Language) -> Expression {
        let relevantVocables = storage.filter { (vocable) -> Bool in
            let rightKind = vocable.kind == kind
            return rightKind && vocable.languages.contains(original)
        }
    }


}