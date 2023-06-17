//
//  SelectedSlotCollectionViewCell.swift
//  Gardner
//
//  Created by Rashid Khan on 23/05/2023.
//

import UIKit

class SelectedSlotCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var lblSlotTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(timeSlot: Date, isSelected: Bool, minHours: Int) {
        viewBG.backgroundColor = isSelected ? UIColor(named: "primaryColor") : UIColor(named: "borderColor")
        lblSlotTime.textColor = isSelected ? .white : UIColor(named: "lightBlackColor")
        
        
        let endTime = Calendar.current.date(byAdding: .hour, value: minHours, to: timeSlot)!.toTimeString()
        lblSlotTime.text = "\(timeSlot.toTimeString()) to \(endTime)"
    }
    
    func configureForEmptyView() {
        self.lblSlotTime.text = "No Slots Available"
        viewBG.backgroundColor = .white
    }
}
