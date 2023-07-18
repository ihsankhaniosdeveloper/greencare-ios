//
//  NotificationsTableViewCell.swift
//  Gardner
//
//  Created by Rashid Khan on 23/06/2023.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }

    func configure(notification: Notification) {
        self.lblTitle.text = notification.title
        self.lblDescription.text = notification.description
    }
}
