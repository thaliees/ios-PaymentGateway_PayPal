//
//  APIPayPalManager.swift
//  PaymentPayPal
//
//  Created by Thaliees on 8/7/20.
//  Copyright © 2020 Thaliees. All rights reserved.
//

import Foundation

class APIPayPalManager: NSObject {
    let baseURL = "https://paymentgateway-braintree.herokuapp.com/api/payment"
    static let sharedInstance = APIPayPalManager()
    
    private var urlSession:URLSession = {
        let newConfiguration:URLSessionConfiguration = .default
        newConfiguration.waitsForConnectivity = false
        newConfiguration.allowsCellularAccess = true
        newConfiguration.timeoutIntervalForRequest = 10
        return URLSession(configuration: newConfiguration)
    }()
    
    func createTransactionPayPal(info: CreateTransactionModel, onSuccess: @escaping (ResponsePayPalModel) -> Void, onFailure: @escaping (String) -> Void) {
        guard let url = URL(string: "\(baseURL)/paypal") else { return onFailure("URL Bad") }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            try request.httpBody = JSONEncoder().encode(info)
        } catch let error {
            onFailure(error.localizedDescription)
        }
        
        let task = urlSession.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil { onFailure(error!.localizedDescription) }
            else {
                let statusResponse = response as! HTTPURLResponse
                do {
                    if statusResponse.statusCode == 200 {
                        let result = try JSONDecoder().decode(ResponsePayPalModel.self, from: data!)
                        onSuccess(result)
                    }
                    else {
                        let result = try JSONDecoder().decode(ErrorModel.self, from: data!)
                        onFailure(result.message)
                    }
                } catch let error {
                    onFailure(error.localizedDescription)
                }
            }
        }
        
        task.resume()
    }
    
    func createTransaction(info: CreateTransactionModel, onSuccess: @escaping (ResponseModel) -> Void, onFailure: @escaping (String) -> Void) {
        guard let url = URL(string: baseURL) else { return onFailure("URL Bad") }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            try request.httpBody = JSONEncoder().encode(info)
        } catch let error {
            onFailure(error.localizedDescription)
        }
        
        let task = urlSession.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil { onFailure(error!.localizedDescription) }
            else {
                let statusResponse = response as! HTTPURLResponse
                do {
                    if statusResponse.statusCode == 200 {
                        let result = try JSONDecoder().decode(ResponseModel.self, from: data!)
                        onSuccess(result)
                    }
                    else {
                        let result = try JSONDecoder().decode(ErrorModel.self, from: data!)
                        onFailure(result.message)
                    }
                } catch let error {
                    onFailure(error.localizedDescription)
                }
            }
        }
        
        task.resume()
    }
}
