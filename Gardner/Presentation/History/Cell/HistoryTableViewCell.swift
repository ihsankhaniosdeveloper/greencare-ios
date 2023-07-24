//
//  HistoryTableViewCell.swift
//  Gardner
//
//  Created by Rashid Khan on 17/06/2023.
//

import UIKit
import SDWebImage

class HistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var ivServiceImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPersons: UILabel!
    @IBOutlet weak var lblHours: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }

    func configure(serviceRequest: ServiceRequest) {
        self.ivServiceImage.sd_setImage(with: URL(string:serviceRequest.service?.image ?? ""), placeholderImage: UIImage(named: "profile_placeholder"), options: SDWebImageOptions(rawValue: 7))
        self.lblTitle.text = serviceRequest.service?.title
        self.lblPersons.text = "Persons: 2"
        self.lblHours.text = "Hours: \(self.getTotalHours(slots: serviceRequest.slot?.slots ?? [], minHours: serviceRequest.service?.minHours ?? 0))"
        self.lblPrice.text = serviceRequest.totalPrice?.formattedAmountWithAED
    }
    
    func getTotalHours(slots: [SlotElement], minHours: Int) -> Int {
        var selectedSlotsCount = 0
        
        slots.forEach { slot in
            selectedSlotsCount += slot.timeSlots?.count ?? 0
        }
        
        return selectedSlotsCount * minHours
    }
    
}
