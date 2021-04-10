//
//  main.swift
//  parser
//
//  Created by Nikita Titov on 17.04.2020.
//  Copyright © 2020 Mourad Amrani. All rights reserved.
//

import Foundation

struct Chapter {
    let number: Int
    let title: String
    let lines: [[String: String]]
}

extension String {
    var isBlank: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension String {
    func isMatching(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

let srcRootURL = URL(fileURLWithPath: "/Volumes/Media0/dev/mac/work/Salaam", isDirectory: true)
let fileURL = srcRootURL.appendingPathComponent("documents", isDirectory: true).appendingPathComponent("english.txt")

// Process text line by line
//
// Header starts with a number.
// Then looped:
// Line 1 is Arabic text
// Line 2 is translated text - English or Dutch
// Line 3 line is latin transliteration

// Read
let content = try! String(contentsOf: fileURL)
let lines = content.components(separatedBy: "\n")

let nonEmpty = lines.filter { !$0.isBlank }

var chapters = [Chapter]()

var rest = nonEmpty

while !rest.isEmpty {
    let s = rest.removeFirst()

    let regex = #"^\d+\."#
    if s.isMatching(regex) {
        var index = 0

        let header = s.components(separatedBy: ".")
        let number = Int(header[0])!
        let title = header[1].trimmingCharacters(in: CharacterSet(charactersIn: ":").union(.whitespacesAndNewlines))

        print(number, title)

        var lines = [[String: String]]()

        while !rest.isEmpty {
            let next = rest.first!
            if next.isMatching(regex) {
                break
            }

            let arabic = rest.removeFirst()
            let translation = rest.removeFirst()
            let transliteration = rest.removeFirst()

            let data = [
               "text": arabic,
               "translationKey": "\(title)_\(index)_Translation",
               "transliterationKey" : "\(title)_\(index)_Transliteration",
               "audioFile" : "\(title)_\(index)"
            ]

            lines.append(data)
            index += 1
        }

        chapters.append(Chapter(number: number, title: title, lines: lines))
    }
}

print(chapters)

// Write
chapters.forEach { ch in
    let title = ch.title
    let lines = ch.lines
    let json = try! JSONSerialization.data(withJSONObject: lines, options: [.prettyPrinted, .sortedKeys])

    let file = srcRootURL.appendingPathComponent("Salaam/src/Data/Versas", isDirectory: true).appendingPathComponent("\(title).json")
    try! json.write(to: file)
}
