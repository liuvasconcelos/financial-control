//
//  BillCell.swift
//  financial-control
//
//  Created by Livia Vasconcelos on 03/11/19.
//  Copyright © 2019 Livia Vasconcelos. All rights reserved.
//

import UIKit

class BillCell: UITableViewCell {
    
    static let cellHeight = 100
    
    var billViewModel: BillViewModel! {
        didSet {
            textLabel?.text = billViewModel.title
            accessoryType   = billViewModel.accessoryType
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textLabel?.font          = .boldSystemFont(ofSize: 24)
        textLabel?.numberOfLines = 0 
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
