//
//  CustomSpinner.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 3/16/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit

class CustomSpinner: UIView {
    private var spinnerImage: UIImageView!
    private var startedSpinning = false
    private var view:UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    init(with myView:UIView, andFrame frame: CGRect){
        super.init(frame: frame)
        view = myView
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        spinnerImage = UIImageView(image:  UIImage(named: "acitivityIndicator"))
    }
    
    func startSpinning(){
        DispatchQueue.main.async {
            self.spinnerImage.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
            self.view?.addSubview(self.spinnerImage)
            self.view?.bringSubview(toFront: self.spinnerImage)
            self.spinnerImage.rotate(duration: 2.0)
            self.startedSpinning = true
        }
    }
    
    func endSpinning(){
        guard startedSpinning else { return }
        UIView.transition(with: spinnerImage, duration: 0.05, options: [.transitionCrossDissolve],
                          animations: {self.spinnerImage.alpha = 0}){ _ in
                            self.spinnerImage.stopRotating()
                            self.spinnerImage.removeFromSuperview()
        }
    }
}


extension UIView {
    private static let kRotationAnimationKey = "rotationanimationkey"
    
    func rotate(duration: Double = 1) {
        if layer.animation(forKey: UIView.kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity
            
            layer.add(rotationAnimation, forKey: UIView.kRotationAnimationKey)
        }
    }
    
    func stopRotating() {
        if layer.animation(forKey: UIView.kRotationAnimationKey) != nil {
            layer.removeAnimation(forKey: UIView.kRotationAnimationKey)
        }
    }
}

