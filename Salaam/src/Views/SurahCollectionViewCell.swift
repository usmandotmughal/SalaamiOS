//
//  SurahCollectionViewCell.swift
//  Salaam
//
//  Created by Andriy Shkinder on 16.12.2019.
//  Copyright © 2019 shkinder.andriy. All rights reserved.
//

import UIKit

extension CALayer {
    func createGradientBorderLayer(colors:[UIColor],width:CGFloat = 1.5, shadow: Bool = false) -> CALayer  {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame =  CGRect(origin: .zero, size: bounds.size)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.colors = colors.map({$0.cgColor})

        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = width
        shapeLayer.path = UIBezierPath(roundedRect: bounds.insetBy(dx: 1.5, dy: 1.5), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: bounds.height / 2.0, height: bounds.height / 2.0)).cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.black.cgColor
    
        if shadow {
            shadowColor =  UIColor(named: "orage_gradient_finish")?.cgColor
            shadowOpacity = 0.8
            shadowRadius = 1.5
            shadowOffset = CGSize(width: 0.0, height: 0.0)
        } else {
            shadowOpacity = 0.0
        }
        
        
        gradientLayer.mask = shapeLayer
        shapeLayer.masksToBounds = false
        
        return gradientLayer
    }
}

class SurahCollectionViewCell: UICollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        icon.image = nil
    }

    override var isHighlighted: Bool {
        didSet {
            if (oldValue != isHighlighted) {
                handleHighlightChage()
            }
        }
    }
    @IBOutlet weak var borderViw: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var translation: UILabel!
    
    private var gradientBorder: CALayer?
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradientBorder?.removeFromSuperlayer()
        gradientBorder = borderViw.layer.createGradientBorderLayer(colors: [UIColor(named: "orange_gradient_start")!, UIColor(named: "orage_gradient_finish")!])
        borderViw.layer.addSublayer(gradientBorder!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientBorder?.removeFromSuperlayer()
        gradientBorder = borderViw.layer.createGradientBorderLayer(colors: [UIColor(named: "orange_gradient_start")!, UIColor(named: "orage_gradient_finish")!])
        borderViw.layer.addSublayer(gradientBorder!)
    }
    
    private func handleHighlightChage() {
        gradientBorder?.removeFromSuperlayer()
        
        gradientBorder = borderViw.layer.createGradientBorderLayer(colors: [UIColor(named: "orange_gradient_start")!, UIColor(named: "orage_gradient_finish")!], shadow: self.isHighlighted)
        borderViw.layer.addSublayer(gradientBorder!)
    }
    
    func update(with surah: Surah) {
        icon.image = surah.icon
        title.text = surah.name
        translation.text = surah.translationKey.localized
    }
    
}
