//
//  AuthenticationRoutes.swift
//  Gardner
//
//  Created by Rashid Khan on 20/04/2023.
//

import Foundation

// Rename this to User Routes
enum UserRoutes {
    case sendOTP(mobileNumber: String)
    case verifyOTP(mobileNumber: String, otp: String)
    case getUser
}

extension UserRoutes: APIRouteType {
    var method: HTTPRequestMethod {
        switch self {
            case .sendOTP, .verifyOTP: return .post
            case .getUser: return .get
        }
    }
    
    var path: String {
        switch self {
            case .sendOTP:   return "v1/auth/login"
            case .verifyOTP: return "v1/auth/verify-otp"
            case .getUser:   return "v1/auth/profile"
        }
    }
    
    var body: [String: Any]? {
        switch self {
            case .sendOTP(let mobileNumber): return ["contact": mobileNumber]
            case .verifyOTP(let mobileNumber, let otp): return ["contact": mobileNumber, "otp": otp]
            case .getUser: return nil
        }
    }
}
