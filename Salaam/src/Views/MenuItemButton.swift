//
//  MenuButton.swift
//  Salaam
//
//  Created by Andriy Shkinder on 08.12.2019.
//  Copyright © 2019 shkinder.andriy. All rights reserved.
//

import UIKit.UIButton

class MenuItemView: UIView {
    @IBOutlet weak var languageView: LanguageView!
    @IBOutlet weak var button: MenuItemButton!
}

class MenuItemButton: UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            layer.shadowColor = UIColor.white.cgColor
            layer.shadowOpacity = isHighlighted ? 0.8 : 0.0
            layer.shadowRadius = isHighlighted ? 2.0 : 0.0
            layer.shadowOffset = .zero
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 1.5
        layer.borderColor = self.tintColor.cgColor
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2.0
    }
    
}
