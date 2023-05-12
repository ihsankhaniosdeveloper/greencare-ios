//
//  ServiceCollectionViewHeader.swift
//  Gardner
//
//  Created by Rashid Khan on 08/05/2023.
//

import UIKit

class ServiceCollectionViewHeader: UICollectionReusableView {
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(title: String) {
        self.lblTitle.text = title
    }
}
