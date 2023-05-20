//
//  SlotsTableViewCell.swift
//  Gardner
//
//  Created by Rashid Khan on 20/05/2023.
//

import UIKit

class SlotsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblSlot: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }

    func configure(timeSlot: Date) {
        let startTime = timeSlot.toTimeString()
        let endTime = Calendar.current.date(byAdding: .hour, value: 1, to: timeSlot)!.toTimeString()
        
        self.lblSlot.text = "\(startTime) to \(endTime)"
    }
    
}
