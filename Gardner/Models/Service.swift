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
    let id, title, description: String?
    let plants, hours, days, persons: [Int]?
    let subType, instructions, type: String?
    let price: Double?
    let minHours: Int?
    let promo: [String]?
    let isDeleted, isActive: Bool?
    let image: String?
    let backgroundImage, contactLink: String?
    let isContactOnly: Bool?
    let createdAt, updatedAt: Date?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, description, plants, hours, days, persons, subType, instructions, type, price, minHours, promo, isDeleted, isActive, image, backgroundImage, contactLink, isContactOnly, createdAt, updatedAt
        case v = "__v"
    }
}
