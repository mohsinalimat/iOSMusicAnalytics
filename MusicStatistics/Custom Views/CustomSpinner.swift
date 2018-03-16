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
    private var rotateTime: TimeInterval = 10
    private var timer: Timer!
    private var tintStatus: Bool!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit(){
        spinnerImage = UIImageView(image:  UIImage(named: "acitivityIndicator"))
    }
    
    func startSpinning(on view:UIView){
        DispatchQueue.main.async {
            self.spinnerImage.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
            view.addSubview(self.spinnerImage)
            view.bringSubview(toFront: self.spinnerImage)
            self.timer = Timer.scheduledTimer(withTimeInterval: self.rotateTime, repeats: true) { _ in
                //            UIView.transition(with: self.spinnerImage, duration: self.rotateTime, options: [.curveEaseInOut],
                //                              animations: {
                //                                //let animation = CGAffineTransform(rotationAngle: 2 * CGFloat.pi)
                //                                //self.spinnerImage.transform = animation
                //                                self.spinnerImage.transform.scaledBy(x: 1.05, y: 1.05)
                //            },
                //                              completion: nil)
                UIView.animate(withDuration: self.rotateTime, animations: {
                    let animation = CGAffineTransform(rotationAngle: 2 * CGFloat.pi)
                    self.spinnerImage.transform = animation
                    
                })
            }
            self.startedSpinning = true
        }
    }
    
    func endSpinning(on view:UIView){
        guard startedSpinning else { return }
        timer.invalidate()
        UIView.transition(with: spinnerImage, duration: 0.25, options: [.transitionCrossDissolve],
                          animations: {self.spinnerImage.alpha = 0}){ _ in
                            self.spinnerImage.removeFromSuperview()
        }
    }
}
