//
//  SurahPlayerViewController.swift
//  Salaam
//
//  Created by Andriy Shkinder on 16.12.2019.
//  Copyright © 2019 shkinder.andriy. All rights reserved.
//

import UIKit

class SurahPlayerViewController: BaseViewController, VersesPlayerDelegate {
    
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var currentVerseView: VerseView!
    @IBOutlet weak var surahEndedContainer: UIView!
    @IBOutlet var surahViews: [UIView]!
    @IBOutlet weak var playerView: AudioPlayerView!
    @IBOutlet weak var surahLogoView: UIImageView!
    @IBOutlet weak var closeButton: BurgerButton!
    
    private var versesPlayer: VersesPlayer!
    private var rightToLeftSwipeRecognizer: UISwipeGestureRecognizer!
    private var leftToRightSwipeRecognizer: UISwipeGestureRecognizer!
    var surah: Surah?
    
    var surahEndedController: SurahEndedViewController? {
        didSet {
            surahEndedController?.repeatHandler = {
                [weak self] in
                self?.versesPlayer.reset()
                self?.currentVerseView.update(with: self!.versesPlayer.verses.first!, animated: false)
                self?.hideSurahEndedMessage()
                self?.versesPlayer.play()
            }
            surahEndedController?.surahNameText = surah?.name ?? ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        surahLogoView.image = surah?.logo
        recreatePlayer()
        currentVerseView.update(with: versesPlayer.currentVerse!)
        surahEndedContainer.alpha = 0.0
        setupGestures()
        closeButton.burgerState = .close
        closeButton.animationEnabled = false
        
        if UIDevice.current.screenType == .iPhones_X_XS {
            logoTopConstraint.constant = 40.0
        }
    }
    
    private func setupGestures() {
        rightToLeftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeLeft))
        rightToLeftSwipeRecognizer.direction = .left
        leftToRightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeRight))
        leftToRightSwipeRecognizer.direction = .right
        view.addGestureRecognizer(rightToLeftSwipeRecognizer)
        view.addGestureRecognizer(leftToRightSwipeRecognizer)
    }
    
    @IBAction func onSwipeLeft() {
        versesPlayer.doGoForward()
    }
    
    @IBAction func onSwipeRight() {
        if self.surahEndedContainer.alpha == 1.0 {
            hideSurahEndedMessage {[weak self] in
                self?.hideSurahEndedMessage()
                self?.versesPlayer.doPlay()
            }
        } else {
            hideSurahEndedMessage()
            versesPlayer.doGoBack()
        }
    }
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func recreatePlayer() {
        guard let surah = surah else { return }
        versesPlayer = VersesPlayer(playerView: playerView, for: surah)
        versesPlayer.delegate = self
    }
    
    private func showSurahEndedMessage() {
        leftToRightSwipeRecognizer.isEnabled = true
        rightToLeftSwipeRecognizer.isEnabled = false
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.surahViews.forEach{ $0.alpha = 0.0 }
                self?.surahEndedContainer.alpha = 1.0
            }
        }
    }
    
    private func hideSurahEndedMessage(onComlete: (()->())? = nil) {
        leftToRightSwipeRecognizer.isEnabled = true
        rightToLeftSwipeRecognizer.isEnabled = true
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, animations: {
                [weak self] in
                self?.surahViews.forEach{ $0.alpha = 1.0 }
                self?.surahEndedContainer.alpha = 0.0
                
            }) { (_) in
                onComlete?()
            }
        }
    }
    
    func versesPlayer(_ player: VersesPlayer, didReachEndOf surah: Surah) {
        showSurahEndedMessage()
    }
    
    func versesPlayer(_ player: VersesPlayer, willStartPlaying verse: Verse) {
        currentVerseView.update(with: verse)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "wrapSurahEndedController" {
            surahEndedController = segue.destination as? SurahEndedViewController
        }
    }
}

