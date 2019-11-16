//
//  DateExtension.swift
//  financial-control
//
//  Created by Livia Vasconcelos on 16/11/19.
//  Copyright © 2019 Livia Vasconcelos. All rights reserved.
//

import Foundation

extension Date {
    func toString(dateFormat format  : String ) -> String {
        let dateFormatter        = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
}
