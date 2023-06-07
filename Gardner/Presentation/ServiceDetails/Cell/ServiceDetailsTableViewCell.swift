//
//  ServiceDetailsTableViewCell.swift
//  Gardner
//
//  Created by Rashid Khan on 13/05/2023.
//

import UIKit

class ServiceDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblMinPersons: UILabel!
    @IBOutlet weak var lblMinHours: UILabel!
    
    var continueButtonTap: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(service: Service) {
        lblTitle.text = service.title
        lblDescription.text = service.description
        lblPrice.text = service.priceWithAED
        lblMinHours.text = String(service.hours?.first ?? 0)
        lblMinPersons.text = String(service.persons?.first ?? 0)
        lblMinHours.text = String(service.minHours ?? 0)
        
    }
    
    @IBAction func continueButtonTap(_ sender: Any) {
        if let continueButtonTap = self.continueButtonTap {
            continueButtonTap()
        }
    }
}
