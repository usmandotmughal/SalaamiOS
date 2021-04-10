//
//  File.swift
//  Salaam
//
//  Created by Andriy Shkinder on 09.12.2019.
//  Copyright © 2019 shkinder.andriy. All rights reserved.
//

import UIKit

class LanguagePickerButton : UIButton {
    
    static func button(for language: Language) -> LanguagePickerButton {
        let button = LanguagePickerButton(frame: CGRect(origin: .zero, size: CGSize(width: 38, height: 38)))
        button.setImage(language.icon, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 38).isActive = true
        button.widthAnchor.constraint(equalToConstant: 38).isActive = true
        return button
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected != oldValue {
                updateSelection()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2.0
    }
    
    private func commonInit() {
        imageEdgeInsets = UIEdgeInsets(top: 3.0, left: 3.0, bottom: 3.0, right: 3.0)
        isSelected = false
    }
    
    private func updateSelection() {
        layer.borderColor = isSelected ? UIColor.white.cgColor : UIColor.clear.cgColor
        layer.borderWidth = 1.5
    }
    
}
