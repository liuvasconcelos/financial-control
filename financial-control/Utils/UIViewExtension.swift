//
//  UIViewExtension.swift
//  financial-control
//
//  Created by Livia Vasconcelos on 03/11/19.
//  Copyright © 2019 Livia Vasconcelos. All rights reserved.
//

import UIKit

extension UIView {
    public static func identifier() -> String {
        return "\(String(describing: self.self))Identifier"
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach{addSubview($0)}
    }
    
    func removeSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
       layer.masksToBounds = false
       layer.shadowColor   = color.cgColor
       layer.shadowOpacity = opacity
       layer.shadowOffset  = offSet
       layer.shadowRadius  = radius

       layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
       layer.shouldRasterize = true
       layer.rasterizationScale = scale ? UIScreen.main.scale : 1
     }
}

extension CALayer {
    func applySketchShadow(color: UIColor  = .black,
                           alpha: Float    = 0.5,
                           x: CGFloat      = 0,
                           y: CGFloat      = 2,
                           blur: CGFloat   = 4,
                           spread: CGFloat = 0) {
        shadowColor   = color.cgColor
        shadowOpacity = alpha
        shadowOffset  = CGSize(width: x, height: y)
        shadowRadius  = blur 
        
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx   = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
        masksToBounds = false
    }
}
