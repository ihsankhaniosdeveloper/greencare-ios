//
//  CartViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 13/05/2023.
//

import UIKit

class CartViewController: UIViewController {
    @IBOutlet weak var viewPromoCode: UIView!

    @IBOutlet weak var ivServiceImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblDeliveryFee: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    private var serviceRequest: ServiceRequest!
    
    static func make(serviceRequest: ServiceRequest) -> CartViewController {
        let vc = CartViewController(nibName: "CartViewController", bundle: .main)
        vc.serviceRequest = serviceRequest
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ivServiceImage.sd_setImage(with: URL(string: self.serviceRequest.service?.image ?? ""), placeholderImage: nil, context: nil)
        lblTitle.text = self.serviceRequest.service?.title
        lblPrice.text = serviceRequest.service?.priceWithAED

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewPromoCode.layer.borderColor = UIColor(named: "primaryColor")!.cgColor
        self.viewPromoCode.layer.borderWidth = 1
        
    }
}
