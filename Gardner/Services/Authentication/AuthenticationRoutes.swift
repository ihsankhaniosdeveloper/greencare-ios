//
//  AuthenticationRoutes.swift
//  Gardner
//
//  Created by Rashid Khan on 20/04/2023.
//

import Foundation

enum AuthenticationRoutes {
    case sendOTP(mobileNumber: String)
    case verifyOTP(otp: String)
}

extension AuthenticationRoutes: APIRouteType {
    var method: HTTPRequestMethod {
        return .post
    }
    
    var url: URL {
        return URL(string: "")!
    }
    
    var path: String {
        switch self {
            case .sendOTP:   return "/v1/send_otp"
            case .verifyOTP: return "/v1/verify_otp"
        }
    }
    
    var body: Data? {
        return nil
//        switch self {
//            case .sendOTP(let mobileNumber) : return User()
//            case .verifyOTP(let otp)        : return User()
//        }
    }
    
    var headers: [String : String] {
        return [:]
    }
}
