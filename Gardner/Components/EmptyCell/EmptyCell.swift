//
//  EmptyCell.swift
//  Gardner
//
//  Created by Rashid Khan on 22/06/2023.
//

import UIKit

class EmptyCell: UITableViewCell {
    @IBOutlet weak var lblMsg: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }

    func configure(message: String) {
        self.lblMsg.text = message
    }
    
}
