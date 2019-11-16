//
//  BillCell.swift
//  financial-control
//
//  Created by Livia Vasconcelos on 03/11/19.
//  Copyright © 2019 Livia Vasconcelos. All rights reserved.
//

import UIKit

class BillCell: UITableViewCell {
    
    static let cellHeight = 60
    
    var billTitle           = UILabel()
    var billCategory        = UILabel()
    var billValue           = UILabel()
    var billStatusIndicator = UIView()
    
    var billViewModel: BillViewModel! {
        didSet {
            billTitle.text                      = billViewModel.title
            billCategory.text                   = billViewModel.category
            billValue.text                      = billViewModel.value
            billStatusIndicator.backgroundColor = billViewModel.statusColor
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.removeSubviews()
        self.addViewElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    fileprivate func addViewElements() {
        self.addSubviews(billTitle, billCategory, billValue, billStatusIndicator)
        
        billTitle.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 4, left: 16, bottom: 0, right: 4), size: CGSize(width: 0, height: 30))
        billTitle.font = .systemFont(ofSize: 14, weight: .semibold)
        
        billCategory.anchor(leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 4, right: 0.6 * frame.width), size: CGSize(width: 0, height: 20))
        billCategory.font = .systemFont(ofSize: 12, weight: .regular)
        
        billValue.anchor(bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 4), size: CGSize(width: 0.3 * frame.width, height: 20))
        billValue.font = .systemFont(ofSize: 12, weight: .bold)
        
        billStatusIndicator.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 4, height: 0))
        billStatusIndicator.backgroundColor = .clear
    }

}
