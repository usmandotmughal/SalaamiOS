//
//  MenuStackView.swift
//  Salaam
//
//  Created by Andriy Shkinder on 08.12.2019.
//  Copyright © 2019 shkinder.andriy. All rights reserved.
//

import UIKit

class MenuStackView: UIStackView {
    
    @IBOutlet weak var languageButton: MenuItemView!
    @IBOutlet weak var feedbackButton: MenuItemView!
    @IBOutlet weak var reviewButton: MenuItemView!

    @IBOutlet weak var languagePickerView: LanguagePickerView!

    override func awakeFromNib() {
        super.awakeFromNib()
        hideLanguagePicker(animated: false)
        updateLocalizable()
    }
    
    func collapse(animated: Bool, completion: ((Bool) -> Void)? = nil) {
        if !animated {
            self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        } else {
            self.animate(appearing: false, completion: completion)
        }
    }
    
    func expand(animated: Bool, completion: ((Bool) -> Void)? = nil) {
        if !animated {
            self.transform = .identity
        } else {
            animate(appearing: true, completion: completion)
        }
    }
    
    private func animate(appearing: Bool, completion:((Bool) -> Void)? = nil ) {
        UIView.animate(
            withDuration: 0.4,
            delay: 0.0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.8,
            options: .curveEaseInOut,
            animations: {
                self.transform = appearing ? CGAffineTransform.identity : CGAffineTransform(scaleX: 0.01, y: 0.01)
                self.alpha = appearing ? 1.0 : 0.0
            },
            completion: completion)
    }
    
    func hideLanguagePicker(animated: Bool, completion:((Bool) -> Void)? = nil) {
           if !animated {
               languagePickerView.isHidden = true
           } else {
            UIView.animate(
                       withDuration: 0.4,
                       delay: 0.0,
                       usingSpringWithDamping: 18,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseInOut,
                       animations: {
                         [weak self]  in
                         self?.languagePickerView.layer.opacity = 0.0
                         self?.languagePickerView.isHidden = true
                         self?.languagePickerView.transform = .identity
                         self?.languageButton.transform = .identity
                         self?.layoutIfNeeded()
                       },
                       completion: nil)
           }
       }
    
    func showLanguagePicker(animated: Bool, completion:((Bool) -> Void)? = nil) {
        if !animated {
            languagePickerView.layer.opacity = 1.0
            languagePickerView.isHidden = false
        } else {
            animateLanguagePicker(appearing: true, completion: completion)
        }
    }
    
    private func animateLanguagePicker(appearing: Bool, completion:((Bool) -> Void)? = nil ) {
        UIView.animate(
            withDuration: 0.4,
            delay: 0.0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.8,
            options: .curveEaseInOut,
            animations: {
                self.languagePickerView.layer.opacity = appearing ? 1.0 : 0.0
                self.languagePickerView.transform = appearing ? CGAffineTransform(translationX: 0.0, y: 20) : .identity
                self.languageButton.transform =  appearing ? CGAffineTransform(translationX: 0.0, y: 60) : .identity
                self.languagePickerView.isHidden = appearing ? false : true
            },
            completion: completion)
    }
    
    @IBAction func didPressLanguageButton(_ sender: Any) {
        languagePickerView.isHidden ? showLanguagePicker(animated: true) : hideLanguagePicker(animated: true)
    }
    
    func updateLocalizable() {
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.languageButton.languageView.title.text = "Language".localized
            self?.feedbackButton.languageView.title.text = "Feedback".localized
            self?.reviewButton.languageView.title.text = "Rating".localized
        }
    }
}
