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
        var pool: [(Expression, context: String)]

        func merge(with: Entry, byLink link: Entry.Link) {
            // do stuff
        }

        init(entry: Entry) {
            pool = []
        }
    }
}

// Entry = ("live" : "English" : "Word") :: (["leben", "wohnen", "siedeln"] :[]: "German" :[]: "Word") :: "XYZ"
// Entry = ("bor" : "Norwegian" : "Word") :: (["live", "reside"] : "English" : "Word") :: ""
//
// *merge*
//
// LinkedEntry = [(("live"    : "English"   : "Word"), "YXZ"),
//                (("reside"  : "English"   : "Word"), ""   ),
//                (("leben"   : "German"    : "Word"), ""   ),
//                (("wohnen"  : "German"    : "Word"), ""   ),
//                (("siedeln" : "German"    : "Word"), ""   ),
//                (("bor"     : "Norwegian" : "Word"), ""   )]
//
//
// *extract entries* (from: "English", "Word", to: "Norwegian")
//