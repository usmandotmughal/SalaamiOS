//
//  main.swift
//  generate_surah_json
//
//  Created by Nikita Titov on 17.04.2020.
//  Copyright © 2020 Mourad Amrani. All rights reserved.
//

import Foundation

extension String {
    var isBlank: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

let srcRootURL = URL(fileURLWithPath: "/Volumes/Media0/dev/mac/work/Salaam", isDirectory: true)
let fileURL = srcRootURL.appendingPathComponent("documents", isDirectory: true).appendingPathComponent("surah.txt")

// Process text line by line

// Read
let content = try! String(contentsOf: fileURL)
let lines = content.components(separatedBy: "\n")

var surah = [[String: String]]()

let nonEmpty = lines.filter { !$0.isBlank }

nonEmpty.forEach { s in
    let s = s.trimmingCharacters(in: .whitespacesAndNewlines)

    // Sample:
    // {
    //  "name":"Al-Ikhlas",
    //  "iconName": "Al-Ikhlas",
    //  "logoName": "Al-Ikhlas-Logo",
    //  "translationKey": "AlIkhlasSurahTranslationKey"
    // },

    let data = [
       "name": s,
       "iconName": "\(s)",
       "logoName" : "\(s)-Logo",
       "translationKey" : "\(s)SurahTranslationKey"
    ]
    surah.append(data)
}

print(surah)

// Write
let json = try! JSONSerialization.data(withJSONObject: surah, options: [.prettyPrinted, .sortedKeys])

let file = srcRootURL.appendingPathComponent("Salaam/src/Data", isDirectory: true).appendingPathComponent("Surah.json")
try! json.write(to: file)
