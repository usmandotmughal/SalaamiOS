//
//  Surah.swift
//  Salaam
//
//  Created by Andriy Shkinder on 16.12.2019.
//  Copyright © 2019 shkinder.andriy. All rights reserved.
//

import UIKit

class Surah: Codable {
    
    var name: String
    var iconName: String
    var logoName: String
    var translationKey: String
    
    var icon: UIImage {
        print(iconName)
        return UIImage(named: iconName)!
    }
    
    var logo: UIImage {
        print(logoName)
        return UIImage(named: logoName)!
    }
}
