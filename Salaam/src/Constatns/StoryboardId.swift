//
//  StoryboardId.swift
//  Salaam
//
//  Created by Andriy Shkinder on 08.12.2019.
//  Copyright © 2019 shkinder.andriy. All rights reserved.
//

import UIKit.UIStoryboard

enum StoryboardId: String {
    
    case menuViewController = "menuVcIdentifier"
    case surahPlayer = "SurahPlayerViewControllerID"
    
    func instantiateViewController<ControllerType>(from storyBoard: UIStoryboard) -> ControllerType {
        return storyBoard.instantiateViewController(withIdentifier: self.rawValue) as! ControllerType
    }
}
