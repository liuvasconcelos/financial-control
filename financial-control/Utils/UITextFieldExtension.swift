//
//  UITextFieldExtension.swift
//  financial-control
//
//  Created by Livia Vasconcelos on 24/11/19.
//  Copyright © 2019 Livia Vasconcelos. All rights reserved.
//

import UIKit

extension UITextField {
    func setBottomBorder(backgroundColor: UIColor = UIColor.white,
                         shadowColor: UIColor = UIColor.lightGray) {
        self.borderStyle = .none
        self.layer.backgroundColor = backgroundColor.cgColor

        self.layer.masksToBounds = false
        self.layer.shadowColor   = shadowColor.cgColor
        self.layer.shadowOffset  = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius  = 0.0
    }
    
}
