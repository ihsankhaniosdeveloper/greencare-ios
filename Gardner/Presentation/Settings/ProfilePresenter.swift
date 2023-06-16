//
//  ProfilePresenter.swift
//  Gardner
//
//  Created by Rashid Khan on 07/05/2023.
//

import Foundation

protocol SettingsServiceType { }

class SettingsService: SettingsServiceType { }

protocol SettingsPresenterOutput: AnyObject {
    func profilePresenter(profileTableData models: [ProfileCell])
}

protocol SettingsPresenterType {
    func getTableData()
}

class ProfilePresenter: SettingsPresenterType {
    weak var outputs: SettingsPresenterOutput?
    private var profileService: SettingsServiceType
    
    init(profileService: SettingsServiceType) {
        self.profileService = profileService
    }
    
    func getTableData() {
        let profileCells: [ProfileCell] = [
            ProfileCell(title: "Personal Details", color: "#E1EADCFF", type: .profileDetails),
            ProfileCell(title: "My Addresses", color: "#D8E5E6FF", type: .myAddresses),
            ProfileCell(title: "Settings", color: "#D6D9DAFF", type: .settings),
            ProfileCell(title: "Support", color: "#D6DBFFFF", type: .support),
            ProfileCell(title: "Logout", color: "#FBF4E2FF", type: .logout),
        ]
        
        self.outputs?.profilePresenter(profileTableData: profileCells)
    }
}

