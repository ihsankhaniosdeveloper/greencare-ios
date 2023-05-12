//
//  DetailsTableViewHeader.swift
//  Gardner
//
//  Created by Rashid Khan on 11/05/2023.
//

import UIKit

class DetailsTableViewHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var viewBG: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    
    var continueButtonTap: (() -> ())?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(service: Service) {
        lblTitle.text = service.title
        lblDescription.text = service.description
        lblPrice.text = service.priceWithAED
    }
    
    @IBAction func continueButtonTap(_ sender: Any) {
        if let continueButtonTap = self.continueButtonTap {
            continueButtonTap()
        }
    }
}
