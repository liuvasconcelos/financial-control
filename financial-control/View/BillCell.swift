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
    
    var bill: Bill! {
        didSet {
            if bill.expireDate >= Date() {
                accessoryType   = .detailDisclosureButton
                textLabel?.text = "\(bill.title) - A vencer!"
            } else {
                accessoryType   = .none
                textLabel?.text = "\(bill.title) - Vencida"
            }
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        contentView.backgroundColor = isHighlighted ? .gray : .white
        textLabel?.textColor        = isHighlighted ? .white : .blue
        detailTextLabel?.textColor  = isHighlighted ? .white : .black
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textLabel?.font          = .boldSystemFont(ofSize: 24)
        textLabel?.numberOfLines = 0
        
        detailTextLabel?.textColor = .black
        detailTextLabel?.font      = .systemFont(ofSize: 20, weight: .light)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
