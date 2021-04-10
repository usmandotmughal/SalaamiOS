//
//  VersesPlayer.swift
//  Salaam
//
//  Created by Andriy Shkinder on 17.12.2019.
//  Copyright © 2019 shkinder.andriy. All rights reserved.
//

import UIKit
import AVFoundation

protocol VersesPlayerDelegate: class {
    func versesPlayer(_ player: VersesPlayer, willStartPlaying verse: Verse)
    func versesPlayer(_ player: VersesPlayer, didReachEndOf surah: Surah)
}

class VersesPlayer:NSObject, AVAudioPlayerDelegate {
    weak var delegate: VersesPlayerDelegate?
    
    private weak var view: AudioPlayerView?
    private var surah: Surah
    var currentVerse: Verse? {
        return verses[currentVerseIndex]
    }
    var verses = [Verse]()
    private var audioPlayer: AVAudioPlayer!
    private var canGoBack: Bool {
        return currentVerseIndex > 0
    }
    
    private var loopCurrentVerse: Bool = false {
        didSet {
            if oldValue == false && loopCurrentVerse == true {
                loopCurrentSurah = false
            }
            updateRepeatButtons()
        }
    }
    private var loopCurrentSurah: Bool = false {
        didSet {
            if oldValue == false && loopCurrentSurah == true {
                loopCurrentVerse = false
            }
            updateRepeatButtons()
        }
    }
    
    private var canGoForward: Bool {
        return currentVerseIndex < verses.count
    }
    
    private var currentVerseIndex = 0 {
        willSet {
            delegate?.versesPlayer(self, willStartPlaying: verses[newValue])
        }
        didSet {
            if currentVerseIndex != oldValue {
                recreateAudioPlayer()
            }
        }
    }
    
    private var playbackTimer: Timer?
    
    deinit {
        playbackTimer?.invalidate()
        playbackTimer = nil
        audioPlayer.stop()
    }
    
    init(playerView: AudioPlayerView, for surah: Surah) {
        self.view = playerView
        self.surah = surah
        super.init()
        preparePlayList()
    }
    
    private func preparePlayList() {
        let filename = "\(surah.name).json"
        print(filename)
        let url = Bundle.main.url(forResource: surah.name, withExtension: "json")!
        let data = try! Data(contentsOf: url)
        verses = try! JSONDecoder().decode([Verse].self, from: data)
        recreateAudioPlayer()
        bindPlayerView()
        
    }
    
    private func recreateAudioPlayer() {
        let title = "\(surah.name)_\(currentVerseIndex)"
        print("\(title).mp3")
        let audioFile = Bundle.main.url(forResource: title, withExtension: "mp3")!

        // Play sound in silent mode
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])

        // Create player
        audioPlayer?.delegate = nil
        audioPlayer = try! AVAudioPlayer(contentsOf: audioFile, fileTypeHint: AVFileType.mp3.rawValue)
        audioPlayer.prepareToPlay()
        audioPlayer.delegate = self
        updateBackForwardButtons()
        recreatePlayBackTimer()
    }
    
    private func bindPlayerView() {
        view?.progressView.progress = 0.0
        view?.playPauseButton.addTarget(self, action: #selector(playPressed(_:)), for: .touchUpInside)
        view?.prevButton.addTarget(self, action: #selector(previousPressed(_:)), for: .touchUpInside)
        view?.nextButton.addTarget(self, action: #selector(nextPressed(_:)), for: .touchUpInside)
        view?.repeatButton.addTarget(self, action: #selector(toogleLoopVerse(_:)), for: .touchUpInside)
        view?.repeatAllButton.addTarget(self, action: #selector(toogleLoopSurah(_:)), for: .touchUpInside)
    }
    
    private func tooglePlayPause() {
        if audioPlayer.isPlaying {
            playbackTimer?.invalidate()
            audioPlayer.pause()
        } else {
            audioPlayer.play()
            recreatePlayBackTimer()
        }
    }
    
    private func updatePlayPauseButton() {
        let imageName = audioPlayer.isPlaying ? "pause" : "play"
        view?.playPauseButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    private func recreatePlayBackTimer() {
        playbackTimer?.invalidate()
        playbackTimer = nil
        playbackTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: {[weak self] (_) in
            self?.updatePlaybackProgress()
        })
    }
    
    @objc func updatePlaybackProgress() {
        let total = audioPlayer.duration
        let progress = audioPlayer.currentTime / total
        self.view?.progressView.progress = Float(progress)
    }
    
    @IBAction func playPressed(_ sender: Any) {
        play()
    }
    
    func play() {
        tooglePlayPause()
        updatePlayPauseButton()
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        doGoForward()
    }
    
    @IBAction func previousPressed(_ sender: Any) {
        doGoBack()
    }
    
    @IBAction func toogleLoopVerse(_ sender: Any) {
        loopCurrentVerse = !loopCurrentVerse
    }
    
    @IBAction func toogleLoopSurah(_ sender: Any) {
        loopCurrentSurah = !loopCurrentSurah
    }
       
    func reset() {
        currentVerseIndex = 0
        recreateAudioPlayer()
    }
    
    func doGoBack() {
        guard canGoBack else { return }
        tooglePlayPause()
        currentVerseIndex -= 1
        recreateAudioPlayer()
        tooglePlayPause()
        updatePlayPauseButton()
    }
    
    
    func doPlay() {
        tooglePlayPause()
        recreateAudioPlayer()
        tooglePlayPause()
        updatePlayPauseButton()
    }
    
    func doGoForward() {
        guard canGoForward else { return }
        if currentVerseIndex != verses.count - 1 {
            tooglePlayPause()
            currentVerseIndex += 1
            recreateAudioPlayer()
            tooglePlayPause()
        } else {
            audioPlayer.pause()
            delegate?.versesPlayer(self, didReachEndOf: surah)
        }
        updatePlayPauseButton()
    }
    
    private func updateBackForwardButtons() {
        view?.prevButton.isEnabled = canGoBack
        view?.nextButton.isEnabled = canGoForward
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            if !loopCurrentVerse {
                if loopCurrentSurah && currentVerseIndex < verses.count - 1 {
                    if canGoForward {
                        doGoForward()
                    }
                } else if loopCurrentSurah && currentVerseIndex == verses.count - 1 {
                    reset()
                    tooglePlayPause()
                    updatePlayPauseButton()
                } else if !loopCurrentSurah {
                    updatePlayPauseButton()
                }
            } else {
                tooglePlayPause()
                updatePlayPauseButton()
            }
        }
    }
    
    private func updateRepeatButtons() {
        view?.repeatButton.tintColor = loopCurrentVerse ? UIColor(named: "orage_gradient_finish") : UIColor.white
        view?.repeatAllButton.tintColor = loopCurrentSurah ? UIColor(named: "orage_gradient_finish") : UIColor.white
    }
}
