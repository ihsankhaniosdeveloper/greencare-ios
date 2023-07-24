//
//  ServiceCollectionViewCell.swift
//  Gardner
//
//  Created by Rashid Khan on 07/05/2023.
//

import UIKit
import SDWebImage

class ServiceCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var ivIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewBG.layer.borderColor = UIColor(named: "borderColor")!.cgColor
    }

    func configure(service: Service) {
        self.lblTitle.text = service.title
        self.ivIcon.sd_setImage(with: URL(string: service.image ?? ""), placeholderImage: UIImage(named: "profile_placeholder"), options: SDWebImageOptions(rawValue: 7))
    }
}
