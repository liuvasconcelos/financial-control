//
//  BillHeader.swift
//  financial-control
//
//  Created by Livia Vasconcelos on 16/11/19.
//  Copyright © 2019 Livia Vasconcelos. All rights reserved.
//

import UIKit

class BillHeader: UIView {
    static let headerHeight: CGFloat = 30.0
    
    func configureHeader(date: Date) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        label.text = date.toString(dateFormat: "dd/MM/yyyy")
        label.font = .systemFont(ofSize: 14, weight: .bold)
        
        self.addSubview(label)
        label.anchor(top:      self.topAnchor,
                     leading:  self.leadingAnchor,
                     bottom:   self.bottomAnchor,
                     trailing: self.trailingAnchor,
                     padding:  UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
    }
}
