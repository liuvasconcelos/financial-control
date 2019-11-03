//
//  financial_controlTests.swift
//  financial-controlTests
//
//  Created by Livia Vasconcelos on 03/11/19.
//  Copyright © 2019 Livia Vasconcelos. All rights reserved.
//

import XCTest
@testable import financial_control

class financial_controlTests: XCTestCase {
    
    func testExpiredBill() {
        let bill          = Bill(id: 1, title: "Title", value: 10.3, expireDate: Date())
        let billViewModel = BillViewModel(bill: bill)
        let billTitle     = "Title - Vencida"
        
        XCTAssertEqual(billTitle, billViewModel.title)
        XCTAssertEqual(UITableViewCell.AccessoryType.none, billViewModel.accessoryType)
    }

    func testNotExpiredBill() {
        let bill          = Bill(id: 1, title: "Title", value: 10.3, expireDate: Date() + 10)
        let billViewModel = BillViewModel(bill: bill)
        let billTitle     = "Title - A vencer!"
        
        XCTAssertEqual(billTitle, billViewModel.title)
        XCTAssertEqual(UITableViewCell.AccessoryType.detailDisclosureButton, billViewModel.accessoryType)
    }
}
