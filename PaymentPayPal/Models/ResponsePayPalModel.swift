//
//  ResponsePayPalModel.swift
//  PaymentPayPal
//
//  Created by Thaliees on 8/7/20.
//  Copyright © 2020 Thaliees. All rights reserved.
//

import Foundation

// MARK: - ResponsePayPalModel
struct ResponsePayPalModel: Codable {
    let id, status, type, currency: String
    let total, taxAmount, merchantAccountID: String
    let orderID: String?
    let createdAt, updatedAt, paymentInstrumentType: String
    let customer: Customer
    let billing, shipping: Address
    let paypalAccount: PaypalAccount

    enum CodingKeys: String, CodingKey {
        case id, status, type, currency, total, taxAmount
        case merchantAccountID = "merchantAccountId"
        case orderID = "orderId"
        case createdAt, updatedAt, paymentInstrumentType, customer, billing, shipping, paypalAccount
    }
}

// MARK: - Customer
struct Customer: Codable {
    let id, name, lastName: String?
}

// MARK: - PaypaAccount
struct PaypalAccount: Codable {
    let token: String?
    let paymentID: String
    let debugID, payeeID: String?
    let payerID, payerEmail, payerName, payerLastName: String
    let payerStatus, sellerProtectionStatus, captureID, transactionFeeAmount: String
    let transactionFeeCurrency: String

    enum CodingKeys: String, CodingKey {
        case token
        case paymentID = "paymentId"
        case debugID = "debugId"
        case payeeID = "payeeId"
        case payerID = "payerId"
        case payerEmail, payerName, payerLastName, payerStatus, sellerProtectionStatus
        case captureID = "captureId"
        case transactionFeeAmount, transactionFeeCurrency
    }
}
