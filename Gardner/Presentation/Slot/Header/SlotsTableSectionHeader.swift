//
//  SlotsTableSectionHeader.swift
//  Gardner
//
//  Created by Rashid Khan on 20/05/2023.
//

import UIKit

class SlotsTableSectionHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var lblDate: UILabel!
    override func awakeFromNib() {
        
    }
    
    func configure(date: Date) {
        self.lblDate.text = date.toDateString()
    }

}
