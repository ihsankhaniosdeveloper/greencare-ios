//
//  Double+CurrencyFormatter.swift
//  Gardner
//
//  Created by Rashid Khan on 27/06/2023.
//

import Foundation

extension Double {
    var formattedAmountWithAED: String {
        return "AED " + String(format: "%.2f", self)
    }
}
