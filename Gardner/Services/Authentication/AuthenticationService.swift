//
//  AuthenticationService.swift
//  Gardner
//
//  Created by Rashid Khan on 18/04/2023.
//

import Foundation
import Alamofire

protocol AuthenticationServiceType {
    func requestOTP(mobileNumber: String, completion: @escaping () -> Void)
    func verifyOTP(otp: String, completion: @escaping () -> Void)
}

class AuthenticationService: AuthenticationServiceType {
    private var apiClinet: APIClientType
    
    init(apiClinet: APIClientType) {
        self.apiClinet = apiClinet
    }
    
    func requestOTP(mobileNumber: String, completion: @escaping () -> Void) {
        self.apiClinet.request(route: AuthenticationRoutes.sendOTP(mobileNumber: "+92 ......")) { response in
        }
    }
    
    func verifyOTP(otp: String, completion: @escaping () -> Void) {
        
    }
}

func test() {
    
}
