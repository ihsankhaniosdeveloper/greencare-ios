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
    
    var token: String {
        get {
            return UserDefaults.standard.string(forKey: "token") ?? ""
        }
    }
    
    var contact: String {
        get {
            return UserDefaults.standard.string(forKey: "contact") ?? ""
        }
    }
    
    var isVerified: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "is.verified")
        }
    }
    
    var isValid: Bool {
        return self.token != "" && self.contact != ""
    }
}
