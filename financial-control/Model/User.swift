//
//  User.swift
//  financial-control
//
//  Created by Livia Vasconcelos on 19/11/19.
//  Copyright © 2019 Livia Vasconcelos. All rights reserved.
//

import Foundation

struct UserResponse: Codable {
    let users: [User]?
    
    enum CodingKeys: String, CodingKey {
        case users = "data"
    }
}

struct User: Codable {
    let id:       Int
    let name:     String
    let email:    String
    let password: String
}
