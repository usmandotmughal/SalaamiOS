//
//  BaseViewController.swift
//  Salaam
//
//  Created by Andriy Shkinder on 08.12.2019.
//  Copyright © 2019 shkinder.andriy. All rights reserved.
//

import UIKit
import SwiftVideoBackground

extension UIDevice {
    var iPhoneX: Bool { UIScreen.main.nativeBounds.height == 2436 }
    var iPhone: Bool { UIDevice.current.userInterfaceIdiom == .phone }
    var iPad: Bool { UIDevice().userInterfaceIdiom == .pad }
    enum ScreenType: String {
        case iPhones_4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhones_X_XS = "iPhone X or iPhone XS"
        case iPhone_XR_11 = "iPhone XR or iPhone 11"
        case iPhone_XSMax_ProMax = "iPhone XS Max or iPhone Pro Max"
        case iPhone_11Pro = "iPhone 11 Pro"
        case unknown
    }
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1792:
            return .iPhone_XR_11
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2426:
            return .iPhone_11Pro
        case 2436:
            return .iPhones_X_XS
        case 2688:
            return .iPhone_XSMax_ProMax
        default:
            return .unknown
        }
    }

}

class LocalizableViewController: UIViewController {
   
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
      
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(forName: .didChangeLanguage, object: nil, queue: .main) { [weak self] (_) in
            self?.updaetLocalizables()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .didChangeLanguage, object: nil)
    }
    
    
    func updaetLocalizables() {
        
    }
}


class BaseViewController: LocalizableViewController {

    private let videoBackground = VideoBackground()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var videoName = "video_background8"
        
        if UIScreen.main.nativeBounds.height == 2778 && UIScreen.main.nativeBounds.width == 1284 ||
            UIScreen.main.nativeBounds.height == 2532 && UIScreen.main.nativeBounds.width == 1170
        {
            videoName = "video_backgroundX"
        }
        
        switch UIDevice.current.screenType {
            case .iPhone_11Pro,. iPhone_XR_11, .iPhones_X_XS, .iPhone_XSMax_ProMax:
            videoName = "video_backgroundX"
        default:
            break
        }
        
        videoBackground.videoGravity = .resizeAspectFill
         try? videoBackground.play(view: view,
                                          videoName: videoName,
                                          videoType: "mp4",
                                          isMuted: true,
                                          darkness: 0.0,
                                          willLoopVideo: true,
                                          preventsDisplaySleepDuringVideoPlayback: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        videoBackground.resume()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        videoBackground.pause()
    }
}
