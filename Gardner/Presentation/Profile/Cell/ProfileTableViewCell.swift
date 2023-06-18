//
//  ProfileTableViewCell.swift
//  Gardner
//
//  Created by Rashid Khan on 18/06/2023.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var ivAvatar: UIImageView!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfPhoneNumber: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
    func configure(profile: UserProfile?) {
        self.ivAvatar.sd_setImage(with: URL(string: profile?.profilePicture ?? ""), placeholderImage: UIImage(named: "ic_profile"), context: nil)
        self.tfFirstName.text = profile?.firstName
        self.tfLastName.text = profile?.lastName
        self.tfPhoneNumber.text = profile?.contact
    }
    
    
    @IBAction func changeAvatarButtonTap(_ sender: Any) {
    }
}
