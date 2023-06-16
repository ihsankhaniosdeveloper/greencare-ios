//
//  CalculateAmountResponse.swift
//  Gardner
//
//  Created by Rashid Khan on 07/06/2023.
//

import Foundation

struct CalculateAmountResponse: Codable {
    let service: Service?
    let slots: [Slot]
    let address: Address
    let promo: String?
    let user: String
    let discount: Double
    let totalPrice: Double
    let discountAmount: Double
    let deliveryFee: Double = 100
}
