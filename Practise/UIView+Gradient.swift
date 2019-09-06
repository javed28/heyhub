//
//  UIView+Gradient.swift
//  Practise
//
//  Created by Javed Siddique on 13/08/19.
//  Copyright © 2019 Alpha Plus Technologies. All rights reserved.
//

import Foundation
import UIKit

enum GradientDirection{
    case leftToRight
    case rightToLeft
    case topToBottom
    case bottomToTop
}
extension UIView {
    
    func gradientBackground(from startColor : UIColor,to endColor : UIColor,direction : GradientDirection){
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [startColor.cgColor,endColor.cgColor]
        switch direction {
            case .leftToRight:
                gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
            case .rightToLeft:
                gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
                gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
            case .topToBottom:
                gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
                gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
            case .bottomToTop:
                gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
                gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
            default:
                break
        }
        self.layer.insertSublayer(gradient, at: 0)
    }
}
