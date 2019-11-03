//
//  Bill.swift
//  financial-control
//
//  Created by Livia Vasconcelos on 03/11/19.
//  Copyright © 2019 Livia Vasconcelos. All rights reserved.
//

import Foundation

struct Bill: Decodable {
    let id:         Int
    let title:      String
    let value:      Double
    let expireDate: Date
}
