//
//  BillViewModel.swift
//  financial-control
//
//  Created by Livia Vasconcelos on 03/11/19.
//  Copyright © 2019 Livia Vasconcelos. All rights reserved.
//

import UIKit

struct BillViewModel {
    
    let id: Int
    let title: String
    let category: String
    let value: String
    let statusColor: UIColor
    let date: String
    let status: String
    
    init(bill: Bill) {
        id       = bill.id
        title    = bill.title
        category = bill.category
        value    = String(bill.value)
        date     = bill.expireDate
        status   = bill.status
        
        if bill.status == "Pago" {
            statusColor = .green
        } else {
            let order = NSCalendar.current.compare(bill.expireDate.toDate(), to: Date(), toGranularity: .day)
            
            if order == .orderedDescending {
                statusColor = .clear
            } else if order == .orderedSame {
                statusColor = .yellow
            } else {
                statusColor = .red
            }
        }
    }
}

struct GroupedBills {
    let date:  Date
    let bills: [BillViewModel]
}
