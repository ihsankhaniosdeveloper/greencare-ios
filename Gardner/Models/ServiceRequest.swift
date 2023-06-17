//
//  ServiceRequest.swift
//  Gardner
//
//  Created by Rashid Khan on 24/05/2023.
//

import Foundation

struct ServiceRequestReponse: Codable {
    let serviceRequest: ServiceRequest
}

// Ask backend for other statuses
enum Status: String, Codable {
    case pending = "pending"
    case schedulled = "schedulled"
}

struct ServiceRequest: Codable {
    let id: String?
    let service: Service?
    let status: Status
    let promo: [String]?
    let address: Address?
    let user: String?
    let discount, totalPrice, discountAmount: Double?
    let isDeleted: Bool?
    let createdAt, updatedAt: Date?
    let v: Int?
    let slot: ServiceRequestSlot?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case service, status, promo, address, user, discount, totalPrice, discountAmount, isDeleted, createdAt, updatedAt
        case v = "__v"
        case slot
    }
}

struct ServiceRequestSlot: Codable {
    let serviceRequest: String?
    let slots: [SlotElement]?
    let isReserved: Bool?
    let id: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case serviceRequest, slots, isReserved
        case id = "_id"
        case v = "__v"
    }
}

struct SlotElement: Codable {
    let date: Date
    let timeSlots: [Date]?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case date, timeSlots
        case id = "_id"
    }
}
