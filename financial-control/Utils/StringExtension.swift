//
//  StringExtension.swift
//  financial-control
//
//  Created by Livia Vasconcelos on 17/11/19.
//  Copyright © 2019 Livia Vasconcelos. All rights reserved.
//

import Foundation

extension String {
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self) ?? Date()
    }
}
