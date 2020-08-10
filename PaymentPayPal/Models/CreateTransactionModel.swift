//
//  CreateTransactionModel.swift
//  PaymentPayPal
//
//  Created by Thaliees on 8/7/20.
//  Copyright © 2020 Thaliees. All rights reserved.
//

import Foundation

// MARK: - CreateTransactionModel
struct CreateTransactionModel: Codable {
    let paymentMethodNonce, deviceData: String
    let totalAmount, taxAmount, discountAmount, shippingAmount: Double
    let currency: String
    let shipping, billing: Address?
    let items: [Item]
}

// MARK: - Shipping
struct Address: Codable {
    let id, name, lastName, address, postalCode: String?
    let city: String?
}

// MARK: - Item
struct Item: Codable {
    let name, productCode, kind, descrip: String
    let quantity, unitAmount, totalAmount, taxAmount: Double
    let discountAmount: Double

    enum CodingKeys: String, CodingKey {
        case name, productCode, kind
        case descrip = "description"
        case quantity, unitAmount, totalAmount, taxAmount, discountAmount
    }
}

// MARK: - ErrorModel
struct ErrorModel: Codable {
    let code: Int
    let message: String
}
