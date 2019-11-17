//
//  Bill.swift
//  financial-control
//
//  Created by Livia Vasconcelos on 03/11/19.
//  Copyright © 2019 Livia Vasconcelos. All rights reserved.
//

import Foundation

struct BillsResponse: Codable {
    let bills: [Bill]?
    
    enum CodingKeys: String, CodingKey {
        case bills = "data"
    }
}

struct Bill: Codable {
    let id:         Int
    let title:      String
    let value:      Double
    let expireDate: String
    let category:   String
    let status:     String
    
    enum CodingKeys: String, CodingKey {
        case id, title, value, category, status
        case expireDate = "expire_date"
    }
}
