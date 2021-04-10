//
//  AudioPlayerView.swift
//  Salaam
//
//  Created by Andriy Shkinder on 17.12.2019.
//  Copyright © 2019 shkinder.andriy. All rights reserved.
//

import UIKit

class RoundedProgress: UIProgressView {

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        self.layer.sublayers?[1].cornerRadius = 2.0
        self.layer.sublayers?[1].masksToBounds = true
    }
}
class AudioPlayerView: UIView {
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var repeatAllButton: UIButton!
    
    

}
