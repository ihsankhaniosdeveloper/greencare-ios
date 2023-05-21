//
//  Service.swift
//  Gardner
//
//  Created by Rashid Khan on 13/05/2023.
//

import Foundation

struct ServiceAdd: Codable {
    let service: String?
    let address: String?
    let slots: [Slot]?
}

struct Service: Codable {
    let id, title, description, subType: String?
    let instructions, type: String?
    let price: Int?
    let promo: [String]?
    let isDeleted, isActive: Bool?
    let image: String?
    let backgroundImage: String?
    let contactLink: String?
    let isContactOnly: Bool?
    let createdAt, updatedAt: Date?
    let v: Int?
    let days, hours, persons, plants: [Int]?
    
    var priceWithAED: String? {
        if let price = self.price {
            return "AED " + String(price)
        }
        
        return nil
    }

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, description, subType, instructions, type, price, promo, isDeleted, isActive, image, backgroundImage, contactLink, isContactOnly, createdAt, updatedAt
        case v = "__v"
        case days, hours, persons, plants
    }
}
