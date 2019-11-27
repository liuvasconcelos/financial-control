//
//  AuthApiDataSource.swift
//  financial-control
//
//  Created by Livia Vasconcelos on 18/11/19.
//  Copyright © 2019 Livia Vasconcelos. All rights reserved.
//

import Foundation

class AuthApiDataSource {
    
    private static var INSTANCE: AuthApiDataSource?
    //    private static let IP = "127.0.0.1"
    private static let IP = "192.168.0.16"

    public static func getInstance() -> AuthApiDataSource {
        return INSTANCE ?? AuthApiDataSource()
    }
    
    public static func destroyInstance() {
        INSTANCE = nil
    }
    
    func login(email: String, password: String, _  loadCallback: @escaping (BaseCallback<User>) -> Void) {
        let urlPath = "http://\(AuthApiDataSource.IP):3000/api/v1/users/"
        
        guard let url = URL(string: urlPath) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
             guard let data = data else { return loadCallback(BaseCallback.failed()) }
            
             do {
                let decoder   = JSONDecoder()
                let users     = try decoder.decode(UserResponse.self, from: data)
                let foundUser = users.users?.filter { $0.email == email && $0.password == password}
                
                if let user = foundUser?.first {
                    loadCallback(BaseCallback.success(user))
                } else {
                    loadCallback(BaseCallback.failed(error: String()))
                }
                 
             } catch {
                loadCallback(BaseCallback.failed(error: String()))
          }
        }.resume()
    }
    
    func saveUser(name: String, email: String, password: String, _ loadCallback: @escaping (BaseCallback<String>) -> Void) {
        let urlPath = "http://\(AuthApiDataSource.IP):3000/api/v1/users"
        
        guard let url  = URL(string: urlPath) else { return }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "POST"
        let parameters = ["name":     name,
                          "email":    email,
                          "password": password] as [String : Any]
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject:parameters, options: []) else { return }
        urlRequest.httpBody = httpBody
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                loadCallback(BaseCallback.failed(error: error))
            } else {
                loadCallback(BaseCallback.success(String()))
            }
        }.resume()
    }
}

