//
//  SlotsTableViewCell.swift
//  Gardner
//
//  Created by Rashid Khan on 20/05/2023.
//

import UIKit

class SlotsTableViewCell: UITableViewCell {
    @IBOutlet weak var checkBoxButton: UIButton!
    
    @IBOutlet weak var lblSlot: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        checkBoxButton.setImage(UIImage(systemName: "square"), for: .normal)
        checkBoxButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
    }

    func configure(timeSlot: Date, isSelected: Bool) {
        let startTime = timeSlot.toTimeString()
        let endTime = Calendar.current.date(byAdding: .hour, value: 1, to: timeSlot)!.toTimeString()
        
        self.lblSlot.text = "\(startTime) to \(endTime)"
        self.checkBoxButton.isSelected = isSelected
    }
    
}
