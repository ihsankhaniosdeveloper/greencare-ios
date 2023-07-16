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
    func profilePresenter(profileTableData models: [SettingsCell])
}

protocol SettingsPresenterType {
    func getTableData()
}

class SettingsPresenter: SettingsPresenterType {
    weak var outputs: SettingsPresenterOutput?
    private var profileService: SettingsServiceType
    
    init(profileService: SettingsServiceType) {
        self.profileService = profileService
    }
    
    func getTableData() {
        let profileCells: [SettingsCell] = [
            SettingsCell(title: "Personal Details", color: "#E1EADCFF", type: .profileDetails),
            SettingsCell(title: "My Addresses", color: "#D8E5E6FF", type: .myAddresses),
            SettingsCell(title: "Support", color: "#D6DBFFFF", type: .support),
            SettingsCell(title: "Logout", color: "#FBF4E2FF", type: .logout),
        ]
        
        self.outputs?.profilePresenter(profileTableData: profileCells)
    }
}

