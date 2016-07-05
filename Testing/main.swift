//
//  main.swift
//  Testing
//
//  Created by Marcus Rossel on 18.06.16.
//  Copyright © 2016 Marcus Rossel. All rights reserved.
//

import Foundation

let german: Language! = Language("German")
let english: Language! = Language("English")
let norwegian: Language! = Language("Norwegian")

let word: Expression.Group! = Expression.Group("Word")
let phrase: Expression.Group! = Expression.Group("Phrase")

var expressions = [Expression]()
expressions.append(Expression("hello", in: english, group: word)) // 0
expressions.append(Expression("How are you doing?", in: english, group: phrase))
expressions.append(Expression("tree", in: english, group: word)) // 2
expressions.append(Expression("car", in: english, group: word))
expressions.append(Expression("much", in: english, group: word)) // 4
expressions.append(Expression("many", in: english, group: word))
expressions.append(Expression("live", in: english, group: word)) // 6
expressions.append(Expression("reside", in: english, group: word))

expressions.append(Expression("hallo", in: german, group: word)) // 8
expressions.append(Expression("Baum", in: german, group: word, context: "der"))
expressions.append(Expression("Auto", in: german, group: word, context: "das")) // 10
expressions.append(Expression("PKW", in: german, group: word, context: "der"))
expressions.append(Expression("viel", in: german, group: word)) // 12
expressions.append(Expression("wohnen", in: german, group: word))
expressions.append(Expression("leben", in: german, group: word)) // 14

expressions.append(Expression("hei", in: norwegian, group: word))
expressions.append(Expression("Hvordan går det?", in: norwegian, group: phrase)) // 16
expressions.append(Expression("tre", in: norwegian, group: word, context: "et"))
expressions.append(Expression("bil", in: norwegian, group: word, context: "en")) // 18
expressions.append(Expression("mye", in: norwegian, group: word))
expressions.append(Expression("mange", in: norwegian, group: word)) // 20
expressions.append(Expression("bor", in: norwegian, group: word))
expressions.append(Expression("lever", in: norwegian, group: word)) // 22

expressions.append(Expression("viele", in: german, group: word)) // 23

let singleSynonyms = expressions.map { Synoset(expression: $0) }

var synonyms = [Synoset]()
synonyms.append(Synoset(expressions: [expressions[0], expressions[1]])) // 0
synonyms.append(Synoset(expressions: [expressions[6], expressions[7]]))
synonyms.append(Synoset(expressions: [expressions[10], expressions[11]])) // 2
synonyms.append(Synoset(expressions: [expressions[13], expressions[14]]))
synonyms.append(Synoset(expressions: [expressions[15], expressions[16]])) // 4
synonyms.append(Synoset(expressions: [expressions[21], expressions[22]]))

var entries: [Lexicon.Entry] = []
entries.append(Lexicon.Entry(title: expressions[2], translations: singleSynonyms[9]))
entries.append(Lexicon.Entry(title: expressions[3], translations: synonyms[2]))
entries.append(Lexicon.Entry(title: expressions[4], translations: singleSynonyms[12]))
entries.append(Lexicon.Entry(title: expressions[5], translations: singleSynonyms[23]))
entries.append(Lexicon.Entry(title: expressions[6], translations: synonyms[3]))

entries.append(Lexicon.Entry(title: expressions[8], translations: synonyms[4]))
entries.append(Lexicon.Entry(title: expressions[9], translations: singleSynonyms[17]))
entries.append(Lexicon.Entry(title: expressions[11], translations: singleSynonyms[18]))
entries.append(Lexicon.Entry(title: expressions[23], translations: singleSynonyms[20]))
entries.append(Lexicon.Entry(title: expressions[14], translations: synonyms[5]))

entries.append(Lexicon.Entry(title: expressions[15], translations: synonyms[0]))

let lexicon = Lexicon(entries: entries)

let result = lexicon.entries(title: english, translations: norwegian)

for entry in result {
  print(entry)
}
