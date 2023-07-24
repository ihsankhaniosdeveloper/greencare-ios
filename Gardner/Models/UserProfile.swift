//
//  UserProfile.swift
//  Gardner
//
//  Created by Rashid Khan on 20/07/2023.
//

import Foundation

struct UserProfile: Codable {
    let contact: String
    let firstName: String?
    let lastName: String?
    let profilePicture: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.contact = try container.decode(String.self, forKey: .contact)
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        self.profilePicture = try container.decodeIfPresent(String.self, forKey: .profilePicture)
    }
}
