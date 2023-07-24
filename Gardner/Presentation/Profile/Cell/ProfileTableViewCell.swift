//
//  ProfileTableViewCell.swift
//  Gardner
//
//  Created by Rashid Khan on 18/06/2023.
//

import UIKit
import SDWebImage

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var ivAvatar: UIImageView!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfPhoneNumber: UITextField!
    
    var saveButtonTapHandler: ((_ image: UIImage?, _ fName: String?, _ lName: String?)->())?
    var changeAvatorTapHandler: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
    func configure(profile: UserProfile?, selectedImage: UIImage?) {
        self.tfFirstName.text = profile?.firstName
        self.tfLastName.text = profile?.lastName
        self.tfPhoneNumber.text = profile?.contact
        
        if let selectedImage = selectedImage {
            self.ivAvatar.image = selectedImage
        } else {
            self.ivAvatar.sd_setImage(with: URL(string: profile?.profilePicture ?? ""), placeholderImage: UIImage(named: "profile_placeholder"), options: SDWebImageOptions(rawValue: 7))
        }
    }
    
    @IBAction func saveButtonTap(_ sender: Any) {
        if let saveButtonTapHandler = self.saveButtonTapHandler {
            saveButtonTapHandler(self.ivAvatar.image, self.tfFirstName.text, self.tfLastName.text)
        }
        
    }
    
    @IBAction func changeAvatarButtonTap(_ sender: Any) {
        if let changeAvatorTapHandler = self.changeAvatorTapHandler {
            changeAvatorTapHandler()
        }
    }
}
