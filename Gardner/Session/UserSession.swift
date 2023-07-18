//
//  UserSession.swift
//  Gardner
//
//  Created by Rashid Khan on 07/05/2023.
//

import Foundation

class UserSession {
    static let instance = UserSession()
    
    private init() { }

    func create(with loginResponse: LoginResponse) {
        UserDefaults.standard.set(loginResponse.accessToken, forKey: "token")
        UserDefaults.standard.set(loginResponse.contact, forKey: "contact")
        UserDefaults.standard.set(loginResponse.isVerified, forKey: "is.verified")
    }
    
    func destroy() {
        UserDefaults.standard.set("", forKey: "token")
        UserDefaults.standard.set("", forKey: "contact")
        UserDefaults.standard.set(false, forKey: "is.verified")
    }
    
    var profile: UserProfile? {
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: "user.profile")
        }
        
        get {
            guard let data = UserDefaults.standard.data(forKey: "user.profile") else { return nil }
            return try? JSONDecoder().decode(UserProfile.self, from: data)
        }
    }
    
    var pushToken: String {
        set {
            UserDefaults.standard.set("user.push.token", forKey: newValue)
        }
        
        get {
            return UserDefaults.standard.string(forKey: "user.push.token") ?? ""
        }
    }
    
    var token: String {
        return UserDefaults.standard.string(forKey: "token") ?? ""
    }
    
    var contact: String {
        return UserDefaults.standard.string(forKey: "contact") ?? ""
    }
    
    var isVerified: Bool {
        return UserDefaults.standard.bool(forKey: "is.verified")
    }
    
    var isValid: Bool {
        return self.token != ""
    }
}
