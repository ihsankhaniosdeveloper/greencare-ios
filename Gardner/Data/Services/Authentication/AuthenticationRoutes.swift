//
//  AuthenticationRoutes.swift
//  Gardner
//
//  Created by Rashid Khan on 20/04/2023.
//

import Foundation

enum AuthenticationRoutes {
    case sendOTP(mobileNumber: String)
    case verifyOTP(mobileNumber: String, otp: String)
}

extension AuthenticationRoutes: APIRouteType {
    var method: HTTPRequestMethod {
        return .post
    }
    
    var path: String {
        switch self {
            case .sendOTP:   return "v1/auth/login"
            case .verifyOTP: return "v1/auth/verify-otp"
        }
    }
    
    var body: [String: Any]? {
        switch self {
            case .sendOTP(let mobileNumber): return ["contact": mobileNumber]
            case .verifyOTP(let mobileNumber, let otp): return ["contact": mobileNumber, "otp": otp]
        }
    }
}
