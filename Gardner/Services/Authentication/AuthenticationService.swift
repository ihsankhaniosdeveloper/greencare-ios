//
//  AuthenticationService.swift
//  Gardner
//
//  Created by Rashid Khan on 18/04/2023.
//

import Foundation
import Alamofire

typealias CompletionClosure<T: Decodable> = (_ result: Result<T, NetworkErrors>) -> Void

struct EmptyResonseDecodable: Decodable {
    
}

protocol AuthenticationServiceType {
    func requestOTP<T: Decodable>(mobileNumber: String, completion: @escaping CompletionClosure<T>)
    func verifyOTP(otp: String, completion: @escaping () -> Void)
}

class AuthenticationService: BaseService, AuthenticationServiceType {
    func requestOTP<T>(mobileNumber: String, completion: @escaping CompletionClosure<T>) where T : Decodable {
        let route = AuthenticationRoutes.sendOTP(mobileNumber: mobileNumber)
        
        self.request(route: route) { (response: T?, error: NetworkErrors?) in
            if let error = error {
                completion(.failure(error))
                return
                
            } else if let response = response {
                completion(.success(response))
                return
            }
            
            completion(.failure(.unknown))
        }
    }
    
    
    
    func verifyOTP(otp: String, completion: @escaping () -> Void) {
        
    }
    
    
    
}

func test() {
    
}
