//
//  Lexicon.LinkedEntry.swift
//  LanguageKit
//
//  Created by Marcus Rossel on 10.06.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

extension Lexicon.Entry {
    public typealias Link = (Language, Synonyms)
}

/*SKETCH*SKETCH*SKETCH*SKETCH*SKETCH*SKETCH*SKETCH*SKETCH*SKETCH*SKETCH*SKETCH*/
extension Lexicon {
    internal struct LinkedEntry /*LinkableEntry;Vocable*/ {
        var pool: [Language: (synonyms: Synonyms, context: String)]
        var group: Entry.Group

        func merge(with: Entry, byLink link: Entry.Link) {
            // do stuff
        }

        init(entry: Entry) {
            group = entry.group
            var protoPool = [Language: (synonyms: Synonyms, context: String)]()
            protoPool[entry.languages.expression] = ([entry.expression], entry.context.expression)
            protoPool[entry.languages.translations] = (Synonyms(entry.translations), entry.context.translations)
            pool = protoPool
        }
    }
}