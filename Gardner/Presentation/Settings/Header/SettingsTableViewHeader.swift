//
//  ProfileTableViewHeader.swift
//  Gardner
//
//  Created by Rashid Khan on 07/05/2023.
//

import UIKit

class SettingsTableViewHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ivPrifile: UIImageView!
    
    var editButtonTapHandler: (()->())?
    func configure(userProfile: UserProfile) {
        if let firstName = userProfile.firstName {
            self.lblName.text = "\(firstName) \(userProfile.lastName ?? "")"
        } else {
            self.lblName.text = ""
        }
        
        self.ivPrifile.sd_setImage(with: URL(string: userProfile.profilePicture ?? ""), placeholderImage: UIImage(named: "profile_placeholder"), context: nil)
    }
    
    @IBAction func editProfileButtonTap(_ sender: Any) {
        if let editButtonTapHandler = self.editButtonTapHandler {
            editButtonTapHandler()
        }
    }
}
