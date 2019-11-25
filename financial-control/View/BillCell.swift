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
    
    var billTitle           = UILabel()
    var billCategory        = UILabel()
    var billValue           = UILabel()
    
    var billStatusIndicator = UIView()
    var mainView            = UIView()
    
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
        self.backgroundColor = UIColor(named: "veryLightGray")
        mainView.frame = CGRect(x: 16, y: 8, width: self.frame.width - 32, height: self.frame.height - 16)
        self.addSubview(mainView)
        mainView.layer.cornerRadius = 5
        mainView.anchor(top:      self.topAnchor,
                        leading:  self.leadingAnchor,
                        bottom:   self.bottomAnchor,
                        trailing: self.trailingAnchor,
                        padding:  UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))

        mainView.backgroundColor = .white
        mainView.layer.applySketchShadow(color: .lightGray, alpha: 0.5, x: 0, y: 3, blur: 8, spread: 3)
        
        mainView.addSubviews(billTitle, billCategory, billValue, billStatusIndicator)
        
        billTitle.anchor(top: mainView.topAnchor, leading: mainView.leadingAnchor, trailing: mainView.trailingAnchor, padding: UIEdgeInsets(top: 4, left: 16, bottom: 0, right: 4), size: CGSize(width: 0, height: 30))
        billTitle.font = .systemFont(ofSize: 16, weight: .semibold)
        
        billCategory.anchor(leading: mainView.leadingAnchor, bottom: mainView.bottomAnchor, trailing: mainView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 4, right: 0.6 * frame.width), size: CGSize(width: 0, height: 20))
        billCategory.font = .systemFont(ofSize: 14, weight: .regular)
        
        billValue.anchor(bottom: mainView.bottomAnchor, trailing: mainView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 4), size: CGSize(width: 0.3 * frame.width, height: 20))
        billValue.font = .systemFont(ofSize: 16, weight: .bold)
        billValue.textAlignment = .center
        
        billStatusIndicator.anchor(top: mainView.topAnchor, leading: mainView.leadingAnchor, bottom: mainView.bottomAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 4, height: 0))
        billStatusIndicator.backgroundColor = .clear
        billStatusIndicator.layer.cornerRadius = 5
    }

}
