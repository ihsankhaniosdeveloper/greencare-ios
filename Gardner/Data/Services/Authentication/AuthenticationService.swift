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

protocol AuthenticationServiceType {
    func requestOTP<T: Decodable>(mobileNumber: String, completion: @escaping CompletionClosure<T>)
    func verifyOTP<T: Decodable>(mobileNumber: String, otp: String, completion: @escaping CompletionClosure<T>)
    func getUser(completion: @escaping CompletionClosure<UserProfile>)
}

class AuthenticationService: BaseService, AuthenticationServiceType {
    func requestOTP<T>(mobileNumber: String, completion: @escaping CompletionClosure<T>) where T : Decodable {
        let route = AuthenticationRoutes.sendOTP(mobileNumber: mobileNumber)
        
        self.request(route: route) { (data: T?, error: NetworkErrors?) in
            if let data = data, error == nil {
                completion(.success(data))
                return
            }
            
            completion(.failure(error ?? .unknown))
        }
    }
    
    func verifyOTP<T>(mobileNumber: String, otp: String, completion: @escaping CompletionClosure<T>) where T : Decodable {
        let route = AuthenticationRoutes.verifyOTP(mobileNumber: mobileNumber, otp: otp)
        
        self.request(route: route) { (data: T?, error: NetworkErrors?) in
            if let data = data, error == nil {
                completion(.success(data))
                return
            }
            
            completion(.failure(error ?? .unknown))
        }
    }
    
    func getUser(completion: @escaping CompletionClosure<UserProfile>) {
        let route = AuthenticationRoutes.getUser
        
        self.request(route: route) { (profile: UserProfile?, error: NetworkErrors?) in
            if let profile = profile, error == nil {
                completion(.success(profile))
                return
            }
            
            completion(.failure(error ?? .unknown))
        }
    }
    
}
