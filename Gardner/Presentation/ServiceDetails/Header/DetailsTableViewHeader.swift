//
//  DetailsTableViewHeader.swift
//  Gardner
//
//  Created by Rashid Khan on 11/05/2023.
//

import UIKit

class DetailsTableViewHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var viewBG: UIView!
    
    var continueButtonTap: (() -> ())?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(service: Service) {
        
    }
    
    @IBAction func continueButtonTap(_ sender: Any) {
        if let continueButtonTap = self.continueButtonTap {
            continueButtonTap()
        }
    }
}
