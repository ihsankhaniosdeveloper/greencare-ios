//
//  ProfileTableViewCell.swift
//  Gardner
//
//  Created by Rashid Khan on 07/05/2023.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewIcon: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(for model: SettingsCell) {
        self.viewIcon.backgroundColor = UIColor(hex: model.color)
        self.lblTitle.text = model.title
    }
    
}
