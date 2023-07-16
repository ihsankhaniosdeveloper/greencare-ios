//
//  ScheduleTableViewCell.swift
//  Gardner
//
//  Created by Rashid Khan on 13/05/2023.
//

import UIKit

class OrdersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ivServiceImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPersons: UILabel!
    @IBOutlet weak var lblHours: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    var indexPath: IndexPath?
    var acceptButtonTapHandler: ((IndexPath) -> ())?
    var rejectButtonTapHandler: ((IndexPath) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
    func configure(serviceRequest: ServiceRequest, indexPath: IndexPath) {
        self.indexPath = indexPath
        
        self.ivServiceImage.sd_setImage(with: URL(string: serviceRequest.service?.image ?? ""), placeholderImage: nil, context: nil)
        self.lblTitle.text = serviceRequest.service?.title
        self.lblPersons.text = "Persons: 2"
        self.lblHours.text = "Hours: \(self.getTotalHours(slots: serviceRequest.slot?.slots ?? [], minHours: serviceRequest.service?.minHours ?? 0))"
        self.lblPrice.text = serviceRequest.totalPrice?.formattedAmountWithAED
        self.lblAddress.text = serviceRequest.address?.completeAddress
        
        self.lblDate.text = serviceRequest
            .slot?.slots?
            .sorted(by: { $0.date < $1.date } )
            .map { $0.date.toDateString(format: "d MMM") }
            .joined(separator: ", ")
    }
    
    func getTotalHours(slots: [SlotElement], minHours: Int) -> Int {
        var selectedSlotsCount = 0
        
        slots.forEach { slot in
            selectedSlotsCount += slot.timeSlots?.count ?? 0
        }
        
        return selectedSlotsCount * minHours
    }
    
    @IBAction func acceptButtonTap(_ sender: Any) {
        guard let indexPath = self.indexPath else { return }
        
        if let acceptButtonTapHandler = self.acceptButtonTapHandler {
            acceptButtonTapHandler(indexPath)
        }
    }
    
    @IBAction func rejectButtonTap(_ sender: Any) {
        guard let indexPath = self.indexPath else { return }
        
        if let rejectButtonTapHandler = self.rejectButtonTapHandler {
            rejectButtonTapHandler(indexPath)
        }
    }
    
    
}
