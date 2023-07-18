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
    func updateProfile(imageData: Data?, fName: String?, lName: String?)
}

protocol ProfilePresenterOutput: AnyObject, LoadingOutputs {
    func profilePresenter(profileFetchSuccess profile: UserProfile)
    func profilePresenter(profileFetchFailed message: String)
    func profilePresenter(profileUpdateSuccess profile: UserProfile)
}

class ProfilePresenter: ProfilePresenterType {
    private var service: AuthenticationServiceType
    
    weak var outputs: ProfilePresenterOutput?
    
    init(service: AuthenticationServiceType) {
        self.service = service
    }
    
    func fetchUserProfile() {
        self.outputs?.startLoading()
        
        self.service.getUser { result in
            self.outputs?.stopLoading()
            
            switch result {
                
            case .success(let profile):
                self.outputs?.profilePresenter(profileFetchSuccess: profile)
                
            case .failure(let error):
                self.outputs?.profilePresenter(profileFetchFailed: error.errorDescription ?? error.localizedDescription)
            }
        }
    }
    
    func updateProfile(imageData: Data?, fName: String?, lName: String?) {
        guard let imageData = imageData else { return }
        guard let firstName = fName else { return }
        guard let lastName = lName else { return }
        
        let profilePicture = ProfilePictureDocument(data: imageData, name: "profilePicture", fileName: "profile.jpg", mimeType: "image/jpeg")
        
        self.outputs?.startLoading()
        self.service.update(profilePicture: profilePicture, fName: firstName, lName: lastName) { result in
            self.outputs?.stopLoading()
            
            switch result {
            case .success(let profile):
                self.outputs?.profilePresenter(profileUpdateSuccess: profile)
                
            case .failure(let error):
                self.outputs?.profilePresenter(profileFetchFailed: error.errorDescription ?? error.localizedDescription)
            }
        }
    }
}
