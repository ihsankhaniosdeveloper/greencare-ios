//
//  EmptyTableViewCell.swift
//  Gardner
//
//  Created by Rashid Khan on 16/06/2023.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {
    @IBOutlet weak var lblError: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(message: String, backgroundColor: UIColor = .clear) {
        self.lblError.text = message
        self.contentView.backgroundColor = backgroundColor
    }
    
}
