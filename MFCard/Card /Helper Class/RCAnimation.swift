//
//  RCAnimation.swift
//  MFCard
//
//  Created by Rahul Chandnani on 13/10/17.
//  Copyright © 2017 MobileFirst Applications. All rights reserved.
//

import Foundation
import UIKit

class RCAnimation: NSObject {
    
    class func vibrateAnimation(_ sender: UIView) {
        let vibrateAnimation = CAKeyframeAnimation()
        vibrateAnimation.keyPath = "transform.rotation"
        let angle: CGFloat = CGFloat((Double.pi/4) / 24)
        vibrateAnimation.values = [-angle, angle, -angle]
        vibrateAnimation.repeatCount = MAXFLOAT
        sender.layer.add(vibrateAnimation, forKey: "shake")
    }
    
    class func fadeAnimation(_ sender: UIView) {
        let animation = CATransition()
        animation.delegate = sender as? CAAnimationDelegate
        animation.type = CATransitionType(rawValue: "fade")
        animation.subtype = CATransitionSubtype(rawValue: "fromTop")
        animation.duration = 1.1
        animation.setValue("fade", forKey: "animType")
        sender.layer.add(animation, forKey: nil)
        sender.isHidden = true
    }
    
    class func rotateAnimation(_ sender: UIView) {
        let animation = CATransition()
        animation.delegate = sender as? CAAnimationDelegate
        animation.type = CATransitionType(rawValue: "rotate")
        animation.subtype = CATransitionSubtype(rawValue: "fromTop")
        animation.duration = 1.1
        animation.setValue("rotate", forKey: "animType")
        sender.layer.add(animation, forKey: nil)
        sender.isHidden = true
    }
    
    class func suckEffectAnimation(_ sender: UIView) {
        let animation = CATransition()
        animation.delegate = sender as? CAAnimationDelegate
        animation.type = CATransitionType(rawValue: "suckEffect")
        animation.subtype = CATransitionSubtype(rawValue: "fromTop")
        animation.duration = 1.3
        animation.setValue("suckEffect", forKey: "animType")
        sender.layer.add(animation, forKey: nil)
        sender.isHidden = true
    }
    
    class func pushAnimation(_ sender: UIView) {
        let animation = CATransition()
        animation.delegate = sender as? CAAnimationDelegate
        animation.type = CATransitionType(rawValue: "push")
        animation.subtype = CATransitionSubtype(rawValue: "fromTop")
        animation.duration = 1.1
        animation.setValue("push", forKey: "animType")
        sender.layer.add(animation, forKey: nil)
        sender.isHidden = true
    }
    
    class func rippleEffectAnimation(_ sender: UIView) {
        let animation = CATransition()
        animation.delegate = sender as? CAAnimationDelegate
        animation.type = CATransitionType(rawValue: "rippleEffect")
        animation.subtype = CATransitionSubtype(rawValue: "fromTop")
        animation.duration = 2.2
        animation.setValue("rippleEffect", forKey: "animType")
        sender.layer.add(animation, forKey: nil)
        sender.isHidden = true
    }
    
    class func cubeEffectAnimation(_ sender: UIView) {
        let animation = CATransition()
        animation.delegate = sender as? CAAnimationDelegate
        animation.type = CATransitionType(rawValue: "cube")
        animation.subtype = CATransitionSubtype(rawValue: "fromTop")
        animation.duration = 1.1
        animation.setValue("cubeEffect", forKey: "animType")
        sender.layer.add(animation, forKey: nil)
        sender.isHidden = true
    }
    
    class func oglFlipAnimation(_ sender: UIView) {
        let animation = CATransition()
        animation.delegate = sender as? CAAnimationDelegate
        animation.type = CATransitionType(rawValue: "oglFlip")
        animation.subtype = CATransitionSubtype(rawValue: "fromTop")
        animation.duration = 1.1
        animation.setValue("oglFlip", forKey: "animType")
        sender.layer.add(animation, forKey: nil)
        sender.isHidden = true
    }
    
    class func toMiniAnimation(_ sender: UIView) {
        let group = CAAnimationGroup()
        group.delegate = sender as? CAAnimationDelegate
        let rotationAni = CABasicAnimation()
        rotationAni.keyPath = "transform.rotation"
        rotationAni.toValue = (Double.pi/2) * 3
        let scaleAni = CABasicAnimation()
        scaleAni.keyPath = "transform.scale"
        scaleAni.toValue = 0.03
        group.duration = 1.0
        group.animations = [rotationAni, scaleAni]
        group.setValue("toMini", forKey: "animType")
        group.isRemovedOnCompletion = false
        group.fillMode = CAMediaTimingFillMode.forwards
        sender.layer.add(group, forKey: nil)
        sender.isHidden = true
    }
}
