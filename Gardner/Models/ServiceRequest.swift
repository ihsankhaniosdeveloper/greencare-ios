//
//  ServiceRequest.swift
//  Gardner
//
//  Created by Rashid Khan on 24/05/2023.
//

import Foundation

enum ServiceRequestStatus: String, Codable {
    case pending = "pending"
    case inProgress = "inProgress"
    case accepted = "accepted"
    case rejected = "rejected"
    case completed = "completed"
    case cancelled = "cancelled"
}

struct ServiceRequest: Codable {
    let id: String
    let service: Service?
    var status: ServiceRequestStatus
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
    
    var totalHours: Int {
        var slotCount = 0
        
        self.slot?.slots?.forEach({ slot in
            slotCount += slot.timeSlots?.count ?? 0
        })
        
        return slotCount * (self.service?.minHours ?? 0)
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
