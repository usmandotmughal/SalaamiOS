//
//  SuahCollectionView.swift
//  Salaam
//
//  Created by Andriy Shkinder on 13.12.2019.
//  Copyright © 2019 shkinder.andriy. All rights reserved.
//

import UIKit

private let InterItemSpacing: CGFloat = 2
private let LineSpacing: CGFloat = 36

class SurahCollectionView: UICollectionView {
    
    let fadePercentage: Double = 0.2
    let gradientLayer = CAGradientLayer()
    let transparentColor = UIColor.clear.cgColor
    let opaqueColor = UIColor.black.cgColor
    
    var topOpacity: CGColor {
        let scrollViewHeight = frame.size.height
        let scrollContentSizeHeight = contentSize.height
        let scrollOffset = contentOffset.y
        let alpha:CGFloat = (scrollViewHeight >= scrollContentSizeHeight || scrollOffset <= 0) ? 1 : 0
        
        let color = UIColor(white: 0, alpha: alpha)
        return color.cgColor
    }
    
    var bottomOpacity: CGColor {
        let scrollViewHeight = frame.size.height
        let scrollContentSizeHeight = contentSize.height
        let scrollOffset = contentOffset.y
        
        let alpha:CGFloat = (scrollViewHeight >= scrollContentSizeHeight || scrollOffset + scrollViewHeight >= scrollContentSizeHeight) ? 1 : 0

        let color = UIColor(white: 0, alpha: alpha)
        return color.cgColor
    }
    
    
    private var flowLayout: UICollectionViewFlowLayout {
        return self.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    private func configureLayout() {
        self.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
        calculateLayout()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        calculateLayout()
        
        let maskLayer = CALayer()
        maskLayer.frame = self.bounds
        
        gradientLayer.frame = CGRect(x: self.bounds.origin.x, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        gradientLayer.colors = [topOpacity, opaqueColor, opaqueColor, bottomOpacity]
        gradientLayer.locations = [0, NSNumber(floatLiteral: fadePercentage), NSNumber(floatLiteral: 1 - fadePercentage), 1]
        maskLayer.addSublayer(gradientLayer)
        
        self.layer.mask = maskLayer

    }
    
    private func calculateLayout() {
        contentInset = .zero
        flowLayout.sectionInset = .zero
        flowLayout.minimumInteritemSpacing = InterItemSpacing
        flowLayout.minimumLineSpacing = LineSpacing
        let itemWidth = (bounds.width - InterItemSpacing ) / 2.0
        let itemHeight: CGFloat = 52
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
    }

}
