//
//  BillViewModel.swift
//  financial-control
//
//  Created by Livia Vasconcelos on 03/11/19.
//  Copyright © 2019 Livia Vasconcelos. All rights reserved.
//

import UIKit

struct BillViewModel {
    
    let title: String
    let accessoryType: UITableViewCell.AccessoryType
    
    init(bill: Bill) {
        if bill.expireDate >= Date() {
            accessoryType = .detailDisclosureButton
            title         = "\(bill.title) - A vencer!"
        } else {
            accessoryType = .none
            title         = "\(bill.title) - Vencida"
        }
    }
}
