//
//  main.swift
//  generate_translation
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

extension String {
    func isMatching(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

["english", "dutch"].forEach { language in
    let srcRootURL = URL(fileURLWithPath: "/Volumes/Media0/dev/mac/work/Salaam", isDirectory: true)
    let fileURL = srcRootURL.appendingPathComponent("documents", isDirectory: true).appendingPathComponent("\(language).txt")

    // Process text line by line

    // Read
    let content = try! String(contentsOf: fileURL)
    let lines = content.components(separatedBy: "\n")

    //Example :
    // //MARK: At-Tin verses translation
    // "At-Tin_0_Translation" = "In the name of Allah,\n the Entirely Merciful, the Especially Merciful.";
    // "At-Tin_0_Transliteration" = "Bismillaahir Rahmaanir Raheem";
    //
    // "At-Tin_1_Translation" = "By the fig and the olive";
    // "At-Tin_1_Transliteration" = "Wat teeni waz zaitoon";
    //
    // "At-Tin_2_Translation" = "And [by] Mount Sinai";
    // "At-Tin_2_Transliteration" = "Wa toori sineen";

    let quote = "\""
    let escapedQuote = "\\\(quote)"

    let nonEmpty = lines.filter { !$0.isBlank }

    var output = [String]()

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

            // Add comment line which will appear in translation file

            output.append("// MARK: \(title) verses translation")
            output.append("")

            while !rest.isEmpty {
                let next = rest.first!
                if next.isMatching(regex) {
                    break
                }

                let arabic = rest.removeFirst()
                let translation = rest.removeFirst()
                let transliteration = rest.removeFirst()

                let safeTranslation = translation.replacingOccurrences(of: quote, with: escapedQuote)
                let safeTransliteration = transliteration.replacingOccurrences(of: quote, with: escapedQuote)


                output.append(#""\#(title)_\#(index)_Translation" = "\#(safeTranslation)";"#)
                output.append(#""\#(title)_\#(index)_Transliteration" = "\#(safeTransliteration)";"#)
                output.append("")

                index += 1
            }

            output.append("")
        }
    }

    // Write
    let text = output.joined(separator: "\n")
    let file = srcRootURL.appendingPathComponent("documents", isDirectory: true).appendingPathComponent("\(language.capitalized).strings")
    try! text.write(to: file, atomically: false, encoding: .utf8)
}
