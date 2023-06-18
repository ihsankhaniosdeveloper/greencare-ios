//
//  ProfilePresenter.swift
//  Gardner
//
//  Created by Rashid Khan on 18/06/2023.
//

import Foundation

struct UserProfile: Codable {
    let contact: String
    let firstName: String?
    let lastName: String?
    let profilePicture: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.contact = try container.decode(String.self, forKey: .contact)
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        self.profilePicture = try container.decodeIfPresent(String.self, forKey: .profilePicture)
    }
}

protocol ProfilePresenterType {
    func fetchUserProfile()
}

protocol ProfilePresenterOutput: AnyObject {
    func profilePresenter(profileFetchSuccess profile: UserProfile)
    func profilePresenter(profileFetchFailed message: String)
}

class ProfilePresenter: ProfilePresenterType {
    private var service: AuthenticationServiceType
    
    weak var outputs: ProfilePresenterOutput?
    
    init(service: AuthenticationServiceType) {
        self.service = service
    }
    
    func fetchUserProfile() {
        self.service.getUser { result in
            switch result {
                
            case .success(let profile):
                self.outputs?.profilePresenter(profileFetchSuccess: profile)
                
            case .failure(let error):
                self.outputs?.profilePresenter(profileFetchFailed: error.errorDescription ?? error.localizedDescription)
            }
        }
    }
}
