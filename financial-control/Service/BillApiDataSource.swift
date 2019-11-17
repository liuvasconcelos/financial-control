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
}
