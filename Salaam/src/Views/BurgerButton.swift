//
//  BurgerButton.swift
//  BurgerButton
//
//  Created by Andriy Shkinder on 22.12.2019.
//  Copyright © 2019 shkinder.andriy. All rights reserved.
//

import UIKit

@IBDesignable
class BurgerButton: UIButton {

    enum BurgerState: Int {
        case menu = 0
        case close = 1
        
        mutating func toogle() {
            self = self == .menu ? .close : .menu
        }
    }
    
    @IBInspectable var lineWidth: CGFloat = 2.5

    public var animationEnabled = true
    public var burgerState = BurgerState.menu {
        didSet {
            if burgerState != oldValue && animationEnabled {
                toogleAnimation()
            }
        }
    }
    
    private let top: CAShapeLayer = CAShapeLayer()
    private let middle: CAShapeLayer = CAShapeLayer()
    private let bottom: CAShapeLayer = CAShapeLayer()

    private var topPath: CGPath {
        let topPath = UIBezierPath()
        topPath.move(to: CGPoint(x: 0, y: 0))
        topPath.addLine(to: CGPoint(x: layer.bounds.width - lineWidth, y: 0))
        return topPath.cgPath
    }
    
    private var middlePath: CGPath {
        let middlePath = UIBezierPath()
        middlePath.move(to: CGPoint(x: 0, y: 0))
        middlePath.addLine(to: CGPoint(x: layer.bounds.width * 0.5 - lineWidth, y: 0))
        return middlePath.cgPath
    }
    
    private var bottomPath: CGPath {
        let bottomPath = UIBezierPath()
        bottomPath.move(to: CGPoint(x: 0, y: 0))
        bottomPath.addLine(to: CGPoint(x: layer.bounds.width * 0.75 - lineWidth, y: 0))
        return bottomPath.cgPath
    }
    
    private var shapeLayers: [CAShapeLayer] {
         return [top, middle, bottom]
     }
    
    override init(frame: CGRect) {
          super.init(frame: frame)
          commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      commonInit()
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        updatePaths()
        positionShapeLayers()
    }
    
    fileprivate func updatePaths() {
        top.path = topPath
        middle.path = middlePath
        bottom.path = bottomPath
    
    }
    
    fileprivate func positionShapeLayers() {
        top.anchorPoint = .zero
        bottom.anchorPoint = .zero
        middle.anchorPoint = .zero
        
        top.position = CGPoint(x: lineWidth / 2.0, y: lineWidth / 2.0)
        middle.position = CGPoint(x: lineWidth / 2.0, y: (layer.bounds.height / 2))
        bottom.position = CGPoint(x: lineWidth / 2.0, y: layer.bounds.height - (lineWidth / 2.0) )
        
    }
    
    private func commonInit() {
    
        for shapeLayer in shapeLayers {
            shapeLayer.lineWidth = lineWidth
            shapeLayer.strokeColor = tintColor.cgColor
            shapeLayer.lineCap = .round
            // Disables implicit animations.
            shapeLayer.actions = [
                "transform": NSNull(),
                "position": NSNull()
            ]
            
            layer.addSublayer(shapeLayer)
        }
        
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
    }
    
    private func toogleAnimation() {
        burgerState == .close ? animateCross() : animateBurger()
    }
    
    @IBAction func touchUpInside() {
        self.burgerState.toogle()
    }
    
    
    private func animateCross() {
        // There's many animations so it's easier to set up duration and timing function at once.
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.4)

        //Animate Top Line
        let topLineAnimation = CABasicAnimation(keyPath: "transform")
        topLineAnimation.toValue = NSValue(caTransform3D: CATransform3DMakeRotation(CGFloat.pi / 4, 0.0, 0.0, 1.0))
        topLineAnimation.fillMode = .forwards;
        topLineAnimation.isRemovedOnCompletion = false
        top.add(topLineAnimation, forKey: "topRotate")
        
        //Animate Middle Line
        let middleLineAnimation = CABasicAnimation(keyPath: "transform")
        middleLineAnimation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(0.0, 1.0, 1.0))
        middleLineAnimation.fillMode = .forwards
        middleLineAnimation.isRemovedOnCompletion = false
        middle.add(middleLineAnimation, forKey: "midScale")
         
        //Animate Bottom Line
        
        let bottomLineAnimation = CABasicAnimation(keyPath: "transform")
        var transform = CATransform3DMakeRotation((-CGFloat.pi / 4), 0.0, 0.0, 1.0)
        transform = CATransform3DScale(transform, 1.333, 1.0, 1.0)
        bottomLineAnimation.toValue = NSValue(caTransform3D: transform)
        bottomLineAnimation.fillMode = .forwards;
        bottomLineAnimation.isRemovedOnCompletion = false
        bottom.add(bottomLineAnimation, forKey: "bottomRotateRotate")
        
        CATransaction.commit()

    }
    
    private func animateBurger() {
        // There's many animations so it's easier to set up duration and timing function at once.
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.4)
        
        //Animate Top Line
        let topLineAnimation = CABasicAnimation(keyPath: "transform")
        if let fromValue = top.presentation()?.transform  {
            topLineAnimation.fromValue = NSValue(caTransform3D:fromValue )
        }
        topLineAnimation.toValue = NSValue(caTransform3D: CATransform3DIdentity)
        topLineAnimation.fillMode = .forwards;
        topLineAnimation.isRemovedOnCompletion = false
        top.add(topLineAnimation, forKey: "topRotate")
        
        //Animate Middle Line
        let midLineAnimation = CABasicAnimation(keyPath: "transform")
        if let fromValue = middle.presentation()?.transform  {
               midLineAnimation.fromValue = NSValue(caTransform3D:fromValue )
        }
        midLineAnimation.toValue = NSValue(caTransform3D: CATransform3DIdentity)
        midLineAnimation.fillMode = .forwards
        midLineAnimation.isRemovedOnCompletion = false
        middle.add(midLineAnimation, forKey: "midScale")
        
        
        let bottomLineAnimation = CABasicAnimation(keyPath: "transform")
        if let fromValue = bottom.presentation()?.transform  {
            bottomLineAnimation.fromValue = NSValue(caTransform3D:fromValue )
        }
        bottomLineAnimation.toValue = NSValue(caTransform3D:CATransform3DIdentity )
        bottomLineAnimation.fillMode = .forwards;
        bottomLineAnimation.isRemovedOnCompletion = false
        bottom.add(bottomLineAnimation, forKey: "bottomRotateRotate")
        
        CATransaction.commit()
    }

}
