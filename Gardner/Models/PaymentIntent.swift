//
//  PaymentIntent.swift
//  Gardner
//
//  Created by Rashid Khan on 20/07/2023.
//

import Foundation

struct PaymentIntentResponse: Codable {
    let paymentIntent: PaymentIntent
}

struct PaymentIntent: Codable {
    let id: String
    let amount: Double
    let clientSecret: String
    let currency: String
    
    enum CodingKeys: String, CodingKey {
        case id, amount
        case clientSecret = "client_secret"
        case currency
    }
}
