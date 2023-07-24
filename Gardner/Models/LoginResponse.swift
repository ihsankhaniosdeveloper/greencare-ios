//
//  LoginResponse.swift
//  Gardner
//
//  Created by Rashid Khan on 22/07/2023.
//

import Foundation

struct LoginResponseWrapper: Decodable {
    let user: LoginResponse
}

struct LoginResponse: Decodable {
    let accessToken: String
    let contact: String
    let isVerified: Bool
    let createdAt: Date
    let updatedAt: Date
}
