//
//  Notification.swift
//  Gardner
//
//  Created by Rashid Khan on 18/07/2023.
//

import Foundation

struct NotificationResponse: Codable {
    let notifications: [Notification]
}

struct Notification: Codable {
    let id: String
    let title: String?
    let description: String?
    let userId: String?
    let v: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, description, userId
        case v = "__v"
    }
}
