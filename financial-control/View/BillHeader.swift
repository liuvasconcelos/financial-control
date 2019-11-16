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
        
        self.addSubview(label)
        label.fillSuperView()
    }
}
