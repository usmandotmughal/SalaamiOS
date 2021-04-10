//
//  LanguagePickerView.swift
//  Salaam
//
//  Created by Andriy Shkinder on 09.12.2019.
//  Copyright © 2019 shkinder.andriy. All rights reserved.
//

import UIKit

class LanguageView: UIView {
    @IBOutlet weak var title: UILabel!

}

class LanguagePickerView: UIView {
    
    private var titleConstraint: NSLayoutConstraint?
    @IBOutlet weak var languageName: UILabel!
    @IBOutlet weak var translatorName: UILabel!

    @IBOutlet weak var titleViw: UIView!
    @IBOutlet weak var buttonsStack: UIStackView!
    
    var onLanguagePicked: Void?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        LocalizatioManager.shared.avaliableLanguages.forEach {
            let button = LanguagePickerButton.button(for: $0)
            button.addTarget(self, action: #selector(pickLanguagePressed(_:)), for: .touchUpInside)
            buttonsStack.addArrangedSubview(button)
        }
        
        preselectLanguage()
        updateWithCurrentLanguage()
        
    }
    
    var selectedIndex: Int {
        get {
            return buttonsStack.arrangedSubviews.firstIndex { (button) -> Bool in
                (button as? LanguagePickerButton)?.isSelected == true
            } ?? 0
        }
    }
    
    private var selectedButton: LanguagePickerButton? {
        return buttonsStack.arrangedSubviews[selectedIndex] as? LanguagePickerButton
    }
    
    override func updateConstraints() {
        let selectedButton = buttonsStack.arrangedSubviews[selectedIndex]
        titleConstraint?.isActive = false
        titleConstraint = NSLayoutConstraint(item: titleViw!, attribute: .centerX, relatedBy: .equal, toItem: selectedButton, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        titleConstraint?.isActive = true
        super.updateConstraints()
    }

    @IBAction func pickLanguagePressed(_ sender: LanguagePickerButton) {
        let newSelectedLanguage = LocalizatioManager.shared.avaliableLanguages[buttonsStack.arrangedSubviews.firstIndex(of: sender)!]
        LocalizatioManager.shared.select(language: newSelectedLanguage)
        
        selectedButton?.isSelected = false
        sender.isSelected = true
        setNeedsUpdateConstraints()

        UIView.animate(withDuration: 0.4) {
            self.layoutIfNeeded()
        }
        updateWithCurrentLanguage()
    }
    
    private func preselectLanguage() {
         let selectedLanguageIndex = LocalizatioManager.shared.avaliableLanguages.firstIndex(where: { (l) -> Bool in
            return l.name == LocalizatioManager.shared.currentLanguage.name
        })!
        
        let button = buttonsStack.arrangedSubviews[selectedLanguageIndex] as! LanguagePickerButton
        button.isSelected = true
    }
    
    private func updateWithCurrentLanguage() {
        languageName.text = LocalizatioManager.shared.currentLanguage.name
        translatorName.text = LocalizatioManager.shared.currentLanguage.quranTranslator
    }
}

