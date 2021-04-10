//
//  SurahEndedViewController.swift
//  Salaam
//
//  Created by Andriy Shkinder on 17.12.2019.
//  Copyright © 2019 shkinder.andriy. All rights reserved.
//

import UIKit
import Gifu

class SurahEndedViewController : UIViewController {
    
    @IBOutlet weak var endingDescription: UILabel!
    @IBOutlet weak var blessing: UILabel!
    @IBOutlet weak var surahName: UILabel!
    
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var repeatImage: GIFImageView!
    
    var surahNameText:String = ""
    
    var repeatHandler: (() -> ())?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        repeatButton.setTitle("Repeat".localized, for: .normal)
        repeatImage.animate(withGIFNamed: "repeatAnimation")
        
//      texts for UILabels
        endingDescription.text = "SurahEnded".localized
        blessing.text = "Blessings".localized
        surahName.text = "Surah \(surahNameText)"

    }
    
    @IBAction func repeatPressed(_ sender: UIButton) {
        repeatHandler?()
    }
    
}
