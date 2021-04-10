//
//  ChooseSurahViewController.swift
//  Salaam
//
//  Created by Andriy Shkinder on 07.12.2019.
//  Copyright © 2019 shkinder.andriy. All rights reserved.
//

import UIKit
import SwiftVideoBackground

class ChooseSurahViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var bottomSpace: NSLayoutConstraint!
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var downArrow: UIButton!
    @IBOutlet weak var splashView: UIView!
    @IBOutlet weak var menuButton: BurgerButton!
    @IBOutlet weak var surahCollectionView: SurahCollectionView!
    var surahs = [Surah]()
    var menuViewController: MenuViewController?    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareData()
        surahCollectionView.dataSource = self
        surahCollectionView.delegate = self
        
        if UIDevice.current.screenType == .iPhones_6_6s_7_8 {
            bottomSpace.constant = 0.0
        }
        
        if UIDevice.current.screenType == .iPhones_X_XS {
            logoTopConstraint.constant = 20.0
            bottomSpace.constant = 17.0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if splashView.alpha == 0 {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            UIView.animate(withDuration: 0.4) {
                self.splashView.alpha = 0.0
            }
        }
    }

    private func prepareData() {
        guard let url = Bundle.main.url(forResource: "Surah", withExtension: "json"),
            let data = try? Data(contentsOf: url) else {
                return
        }
        
        surahs =  try! JSONDecoder().decode([Surah].self, from: data)
    }
    
    private func showMenu() {
        menuViewController = StoryboardId.menuViewController.instantiateViewController(from: .main)
        view.insertSubview(menuViewController!.view, belowSubview: menuButton)
        menuViewController?.view.frame = view.bounds
        addChild(menuViewController!)
        menuViewController?.didMove(toParent: self)
    }
    
    private func hideMenu() {
        menuViewController?.willMove(toParent: nil)
        menuViewController?.removeFromParent()
        menuViewController?.view.removeFromSuperview()
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        menuButton.burgerState == .close
            ? showMenu() : hideMenu()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return surahs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SurahCell", for: indexPath) as! SurahCollectionViewCell
        let surah = surahs[indexPath.item]
        cell.update(with: surah)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc: SurahPlayerViewController = StoryboardId.surahPlayer.instantiateViewController(from: .main)
        vc.surah = surahs[indexPath.item]
        present(vc, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let surahView = scrollView as? SurahCollectionView else {
            return
        }
        surahView.gradientLayer.colors = [surahView.topOpacity, surahView.opaqueColor, surahView.opaqueColor, surahView.bottomOpacity]
    }
    override func updaetLocalizables() {
        super.updaetLocalizables()
        surahCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var surahHeight = NSLayoutConstraint(item: surahCollectionView!, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.517, constant: 0)

        downArrow.isHidden = true
        switch UIDevice.current.screenType {
            case .iPhone_11Pro,. iPhone_XR_11, .iPhones_X_XS, .iPhone_XSMax_ProMax:
                surahHeight = NSLayoutConstraint(item: surahCollectionView!, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.617, constant: 0)
            case .iPhones_6_6s_7_8:
               surahHeight = NSLayoutConstraint(item: surahCollectionView!, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.59, constant: 0)
            default:
                break
        }
        view.addConstraint(surahHeight)

        surahCollectionView.indexPathsForSelectedItems?.forEach{
            surahCollectionView.deselectItem(at: $0, animated: true)
        }
    }
}

