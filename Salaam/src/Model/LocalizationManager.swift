//
//  LocalisationManager.swift
//  Salaam
//
//  Created by Andriy Shkinder on 11.12.2019.
//  Copyright © 2019 shkinder.andriy. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let didChangeLanguage = Notification.Name("didChangeLanguage")
}

extension String {
    var localized: String {
        return LocalizatioManager.shared.string(for: self)
    }
}

final class LocalizatioManager {
    
    private static let decoder = JSONDecoder()
    private static let encoder = JSONEncoder()
    private static let CurrentLanguageDefaultsKey = "CurrentLanguage"
    private var strings: NSDictionary!
    let avaliableLanguages: [Language]
    
    var currentLanguage: Language {
        
        get {
            guard let persisted = UserDefaults.standard.data(forKey: LocalizatioManager.CurrentLanguageDefaultsKey) else {
                return LocalizatioManager.defaultLanguage
            }
            
            return try! LocalizatioManager.decoder.decode(Language.self, from: persisted)
        }
        
        set {
            let data = try! LocalizatioManager.encoder.encode(newValue)
            UserDefaults.standard.set(data, forKey: LocalizatioManager.CurrentLanguageDefaultsKey)
            updateStrings()
            NotificationCenter.default.post(name: .didChangeLanguage, object: nil)
        }
    }
    
    static let shared = LocalizatioManager(languages:[
        Language(name: "English", translator: "Saheeh International", iconName:"english"),
        Language(name: "Nederlands", translator: "Sofjan S. Siregar", iconName:"dutch")
    ])
    
    private static let defaultLanguage = Language(name: "English", translator: "Saheeh International", iconName: "english")
    
    
    private init(languages: [Language]) {
        self.avaliableLanguages = languages
        updateStrings()
    }
    
    private func updateStrings() {
        guard let url = Bundle.main.url(forResource: currentLanguage.name, withExtension: "strings") else {
            print("No String file found f")
            return
        }
        
        strings = NSDictionary(contentsOf: url)
    }
    
    func string(for key: String) -> String {
        print(key)
        return strings![key] as! String
    }
    
    func select(language: Language) {
        currentLanguage = language
    }
}
