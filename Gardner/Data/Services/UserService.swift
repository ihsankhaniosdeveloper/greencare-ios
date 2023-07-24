//
//  AuthenticationService.swift
//  Gardner
//
//  Created by Rashid Khan on 18/04/2023.
//

import Foundation

// MARK: - Service Type
protocol UserServiceType {
    func requestOTP<T: Decodable>(mobileNumber: String, pushToken: String, completion: @escaping CompletionClosure<T>)
    func verifyOTP<T: Decodable>(mobileNumber: String, otp: String, completion: @escaping CompletionClosure<T>)
    func getUser(completion: @escaping CompletionClosure<UserProfile>)
    func update(profilePicture: ProfilePictureDocument, fName: String, lName: String, completion: @escaping CompletionClosure<UserProfile>)
}

// MARK: - Service Implementation
class UserService: BaseService, UserServiceType {
    func update(profilePicture: ProfilePictureDocument, fName: String, lName: String, completion: @escaping CompletionClosure<UserProfile>) {
        self.upload(document: profilePicture, route: UserRoutes.updateProfile, otherFormValues: ["firstName": fName, "lastName": lName]) { (data: UserProfile?, error: NetworkErrors?) in
            if let data = data, error == nil {
                completion(.success(data))
                return
            }
            
            completion(.failure(error ?? .unknown))
        }
    }
    
    func requestOTP<T>(mobileNumber: String, pushToken: String, completion: @escaping CompletionClosure<T>) where T : Decodable {
        let route = UserRoutes.sendOTP(mobileNumber: mobileNumber, pushToken: pushToken, userType: .customer)
        
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

// MARK: - Routes
fileprivate enum UserRoutes {
    case sendOTP(mobileNumber: String, pushToken: String, userType: UserType)
    case verifyOTP(mobileNumber: String, otp: String)
    case getUser
    case updateProfile
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
