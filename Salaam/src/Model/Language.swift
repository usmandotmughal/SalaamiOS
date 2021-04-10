//
//  Language.swift
//  Salaam
//
//  Created by Andriy Shkinder on 11.12.2019.
//  Copyright © 2019 shkinder.andriy. All rights reserved.
//

import UIKit

class Language: Codable {
    
    var name: String
    var quranTranslator: String
    var iconName: String
    
    var icon: UIImage {
        return UIImage(named: iconName)!
    }
    
    init(name: String, translator: String, iconName: String) {
        self.name = name
        self.quranTranslator = translator
        self.iconName = iconName
    }
}
