//
//  VerseView.swift
//  Salaam
//
//  Created by Andriy Shkinder on 17.12.2019.
//  Copyright © 2019 shkinder.andriy. All rights reserved.
//

import UIKit

class VerseView: UIView {
    @IBOutlet weak var translation: UILabel!
    @IBOutlet weak var original: UILabel!
    @IBOutlet weak var transliteration: UILabel!
    
    
    func update(with verse: Verse, animated: Bool = true) {
        UIView.transition(with: self, duration: animated ? 0.4 : 0.0 , options: .transitionCrossDissolve, animations: {
            self.translation.text = verse.translationKey.localized
            self.original.text = verse.text
            self.transliteration.text = verse.transliterationKey.localized
        }, completion: nil)
    }
}
