//
//  BillApiDataSource.swift
//  financial-control
//
//  Created by Livia Vasconcelos on 17/11/19.
//  Copyright © 2019 Livia Vasconcelos. All rights reserved.
//

import Foundation

class BillApiDataSource {
    
    private static var INSTANCE: BillApiDataSource?

    public static func getInstance() -> BillApiDataSource {
        return INSTANCE ?? BillApiDataSource()
    }
    
    public static func destroyInstance() {
        INSTANCE = nil
    }
    
    func getAllBills(_ loadCallback: @escaping (BaseCallback<BillsResponse>) -> Void) {
        let urlPath = "http://127.0.0.1:3000/api/v1/accounts/"
        
        guard let url = URL(string: urlPath) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
             guard let data = data else { return loadCallback(BaseCallback.failed()) }
            
             do {
                let decoder = JSONDecoder()
                let bills = try decoder.decode(BillsResponse.self, from: data)
                
                loadCallback(BaseCallback.success(bills))
                 
             } catch {
                loadCallback(BaseCallback.failed(error: error))
          }
        }.resume()
    }
    
    func deleteBillWith(id: Int, _ loadCallback: @escaping (BaseCallback<String>) -> Void) {
        let urlPath = "http://127.0.0.1:3000/api/v1/accounts/\(id)"
        
        guard let url  = URL(string: urlPath) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                loadCallback(BaseCallback.failed(error: error))
            } else {
                loadCallback(BaseCallback.success(String()))
            }
        }.resume()
    }
    
    func changeStatus(id: Int, status: String, _ loadCallback: @escaping (BaseCallback<String>) -> Void) {
        let urlPath = "http://127.0.0.1:3000/api/v1/accounts/\(id)"
        
        guard let url  = URL(string: urlPath) else { return }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "PUT"
        let parameters = ["status": status] as [String : Any]
        
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
    
    func saveAccount(bill: Bill, edition: Bool, _ loadCallback: @escaping (BaseCallback<String>) -> Void) {
        let urlPath = edition ? "http://127.0.0.1:3000/api/v1/accounts/\(bill.id)" : "http://127.0.0.1:3000/api/v1/accounts/"
        
        guard let url  = URL(string: urlPath) else { return }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = edition ? "PUT": "POST"
        let parameters = ["title":       bill.title,
                          "value":       bill.value,
                          "expire_date": bill.expireDate,
                          "category":    bill.category,
                          "status":      edition ? bill.status : "Não pago"] as [String : Any]
        
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
