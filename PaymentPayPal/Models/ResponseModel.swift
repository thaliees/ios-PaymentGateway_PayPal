//
//  ResponseModel.swift
//  PaymentPayPal
//
//  Created by Thaliees on 8/7/20.
//  Copyright © 2020 Thaliees. All rights reserved.
//

import Foundation

// MARK: - ResponseModel
struct ResponseModel: Codable {
    let id, status, type, currency: String
    let total, taxAmount, merchantAccountID: String
    let orderID: String?
    let createdAt, updatedAt, paymentInstrumentType: String
    let customer: Customer
    let billing, shipping: Address
    let creditCard: CreditCard

    enum CodingKeys: String, CodingKey {
        case id, status, type, currency, total, taxAmount
        case merchantAccountID = "merchantAccountId"
        case orderID = "orderId"
        case createdAt, updatedAt, paymentInstrumentType, customer, billing, shipping, creditCard
    }
}

// MARK: - PaypaAccount
struct CreditCard: Codable {
    let token: String?
    let bin, last4, cardType: String
    let expirationMonth, expirationYear, expirationDate, customerLocation: String
    let cardHolderName: String?
    let debit, prepaid, commercial, healthcare, payroll: String
}
