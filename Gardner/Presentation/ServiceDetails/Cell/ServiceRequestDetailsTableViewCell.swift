//
//  ServiceDetailsTableViewCell.swift
//  Gardner
//
//  Created by Rashid Khan on 13/05/2023.
//

import UIKit

class ServiceRequestDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblMinPersons: UILabel!
    @IBOutlet weak var lblMinHours: UILabel!
    @IBOutlet weak var lblSlot: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    
    var continueButtonTap: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }

    func configure(serviceRequest: ServiceRequest) {
        let service = serviceRequest.service
        
        lblTitle.text = service?.title
        lblDescription.text = service?.description
        lblPrice.text = service?.price?.formattedAmountWithAED
        lblMinHours.text = String(service?.hours?.first ?? 0)
        lblMinPersons.text = "2"
        lblMinHours.text = "\(serviceRequest.totalHours)"
        lblSlot.text = serviceRequest.status.rawValue.capitalized
        
        var title = "Process"
        switch serviceRequest.status {
            case .pending, .cancelled, .rejected, .accepted: break
            case .inProgress: title = "Complete"
            case .completed: title = "Service Completed"
        }
        btnContinue.setTitle(title, for: .normal)
    }
    
    @IBAction func continueButtonTap(_ sender: Any) {
        if let continueButtonTap = self.continueButtonTap {
            continueButtonTap()
        }
    }
}
