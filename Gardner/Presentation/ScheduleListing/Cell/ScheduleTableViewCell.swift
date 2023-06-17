//
//  ScheduleTableViewCell.swift
//  Gardner
//
//  Created by Rashid Khan on 13/05/2023.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblPersonsAndHours: UILabel!
    @IBOutlet weak var lblCreatedAt: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
    func configure(serviceRequest: ServiceRequest) {
        self.lblTitle.text = serviceRequest.service?.title
        self.lblDate.text =  serviceRequest
            .slot?.slots?
            .sorted(by: { $0.date < $1.date } )
            .map { $0.date.toDateString(format: "d MMM") }
            .joined(separator: ", ")
        
//        self.lblSubtitle.text = serviceRequest.service?
        self.lblPersonsAndHours.text = "2 Persons/\(getTotalHours(slots: serviceRequest.slot?.slots ?? [], minHours: serviceRequest.service?.minHours ?? 0)) Hours"
        
        self.lblCreatedAt.text = "Created at: \(serviceRequest.createdAt?.toDateString() ?? "")"
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
