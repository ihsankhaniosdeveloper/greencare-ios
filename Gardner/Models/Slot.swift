//
//  Slot.swift
//  Gardner
//
//  Created by Rashid Khan on 28/05/2023.
//

import Foundation

struct SlotsResponse: Codable {
    let slots: [Slot]?
    let type: String?
    let reservedSlots: [ReservedSlot]?
    let startDate: Date?
    let endDate: Date?
}

struct Slot: Codable {
    let date: Date
    let timeSlots: [Date]
    
    var isExpanded: Bool? = false
    
    enum CodingKeys: CodingKey {
        case date
        case timeSlots
        case isExpanded
    }
    
    init(date: Date, timeSlots: [Date]) {
        self.date = date
        self.timeSlots = timeSlots
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.date = try container.decode(Date.self, forKey: .date)
        self.timeSlots = try container.decode([Date].self, forKey: .timeSlots)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.date, forKey: .date)
        try container.encode(self.timeSlots, forKey: .timeSlots)
    }
}

struct ReservedSlot: Codable {
    let id, serviceRequest: String?
    let slots: [ReservedSlotSlot]?
    let isReserved: Bool?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case serviceRequest, slots, isReserved
        case v = "__v"
    }
}

struct ReservedSlotSlot: Codable {
    let date: String?
    let timeSlots: [Date]?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case date, timeSlots
        case id = "_id"
    }
}
