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
    func requestOTP<T: Decodable>(mobileNumber: String, pushToken: String, userType: UserType, completion: @escaping CompletionClosure<T>)
    func verifyOTP<T: Decodable>(mobileNumber: String, otp: String, completion: @escaping CompletionClosure<T>)
    func getUser(completion: @escaping CompletionClosure<UserProfile>)
    func update(profilePicture: ProfilePictureDocument, fName: String, lName: String, completion: @escaping CompletionClosure<UserProfile>)
}

class AuthenticationService: BaseService, AuthenticationServiceType {
    func update(profilePicture: ProfilePictureDocument, fName: String, lName: String, completion: @escaping CompletionClosure<UserProfile>) {
        let route = UserRoutes.updateProfile(firstName: fName, lastName: lName)
        
        self.upload(document: profilePicture, route: route, otherFormValues: ["firstName": fName, "lastName": lName]) { (data: UserProfile?, error: NetworkErrors?) in
            if let data = data, error == nil {
                completion(.success(data))
                return
            }
            
            completion(.failure(error ?? .unknown))
        }
    }
    
    func requestOTP<T>(mobileNumber: String, pushToken: String, userType: UserType, completion: @escaping CompletionClosure<T>) where T : Decodable {
        let route = UserRoutes.sendOTP(mobileNumber: mobileNumber, pushToken: pushToken, userType: userType)
        
        self.request(route: route) { (data: T?, error: NetworkErrors?) in
            if let data = data, error == nil {
                completion(.success(data))
                return
            }
            
            completion(.failure(error ?? .unknown))
        }
    }
    
    func verifyOTP<T>(mobileNumber: String, otp: String, completion: @escaping CompletionClosure<T>) where T : Decodable {
        let route = UserRoutes.verifyOTP(mobileNumber: mobileNumber, otp: otp)
        
        self.request(route: route) { (data: T?, error: NetworkErrors?) in
            if let data = data, error == nil {
                completion(.success(data))
                return
            }
            
            completion(.failure(error ?? .unknown))
        }
    }
    
    func getUser(completion: @escaping CompletionClosure<UserProfile>) {
        let route = UserRoutes.getUser
        
        self.request(route: route) { (profile: UserProfile?, error: NetworkErrors?) in
            if let profile = profile, error == nil {
                completion(.success(profile))
                return
            }
            
            completion(.failure(error ?? .unknown))
        }
    }
    
}
