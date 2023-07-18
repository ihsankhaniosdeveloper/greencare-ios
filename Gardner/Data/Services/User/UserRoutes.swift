//
//  AuthenticationRoutes.swift
//  Gardner
//
//  Created by Rashid Khan on 20/04/2023.
//

import Foundation

enum UserType: String {
    case customer = "user"
    case supplier = "supplier"
}
enum UserRoutes {
    case sendOTP(mobileNumber: String, pushToken: String, userType: UserType)
    case verifyOTP(mobileNumber: String, otp: String)
    case getUser
    case updateProfile(firstName: String, lastName: String)
}

extension UserRoutes: APIRouteType {
    var method: HTTPRequestMethod {
        switch self {
            case .sendOTP, .verifyOTP: return .post
            case .getUser: return .get
            case .updateProfile: return .put
        }
    }
    
    var path: String {
        switch self {
            case .sendOTP:   return "v1/auth/login"
            case .verifyOTP: return "v1/auth/verify-otp"
            case .getUser, .updateProfile:   return "v1/auth/profile"
        }
    }
    
    var body: [String: Any]? {
        switch self {
            case .sendOTP(let mobileNumber, let pushToken, let userType): return ["contact": mobileNumber, "deviceToken": pushToken, "type": userType.rawValue]
            case .verifyOTP(let mobileNumber, let otp): return ["contact": mobileNumber, "otp": otp]
            case .getUser: return nil
            case .updateProfile: return nil
        }
    }
}
