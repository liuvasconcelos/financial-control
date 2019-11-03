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
}
