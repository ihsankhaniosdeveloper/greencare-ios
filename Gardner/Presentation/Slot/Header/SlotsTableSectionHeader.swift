//
//  SlotsTableSectionHeader.swift
//  Gardner
//
//  Created by Rashid Khan on 20/05/2023.
//

import UIKit

class SlotsTableSectionHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var ivExpandedIcon: UIImageView!
    
    @IBOutlet weak var lblDate: UILabel!
    override func awakeFromNib() {
        
    }
    
    func configure(date: Date, isExpanded: Bool) {
        self.lblDate.text = date.toDateString()
        
        self.ivExpandedIcon.image = isExpanded ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")
    }

}
