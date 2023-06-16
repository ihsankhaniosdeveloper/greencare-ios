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
    @IBOutlet weak var lblHours: UILabel!
    @IBOutlet weak var lblPersons: UILabel!
    @IBOutlet weak var lblPromoCode: UILabel!
    
    private var serviceRequest: CalculateAmountResponse!
    private var selectedSlots: [Slot] = []
    
    static func make(serviceRequest: CalculateAmountResponse, selectedSlots: [Slot]) -> CartViewController {
        let vc = CartViewController(nibName: "CartViewController", bundle: .main)
        vc.serviceRequest = serviceRequest
        vc.selectedSlots = selectedSlots
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Invoice"
        self.populateData()
        
        self.navigationController?.popToRootViewController(animated: false)
    }
}

fileprivate extension CartViewController {
    func populateData() {
        self.ivServiceImage.sd_setImage(with: URL(string: self.serviceRequest.service?.image ?? ""), placeholderImage: nil, context: nil)
        self.lblTitle.text = self.serviceRequest.service?.title
        self.lblPrice.text = serviceRequest.service?.price?.formattedAmountWithAED
        self.lblHours.text = "Hours: \(self.getTotalHours())"
        self.lblPersons.text = "Persons: 2"
        self.lblDate.text = Date().toDateString()
        self.lblSubTotal.text = serviceRequest.totalPrice.formattedAmountWithAED
        self.lblDeliveryFee.text = serviceRequest.deliveryFee.formattedAmountWithAED
        self.lblTotal.text = (serviceRequest.totalPrice + serviceRequest.deliveryFee).formattedAmountWithAED
    }
    
    func getTotalHours() -> Int {
        var selectedSlotsCount = 0
        
        self.selectedSlots.forEach { slot in
            selectedSlotsCount += slot.timeSlots.count
        }
        
        return selectedSlotsCount * (self.serviceRequest.service?.minHours ?? 0)
    }
}

extension Double {
    var formattedAmountWithAED: String {
        return "AED " + String(format: "%.2f", self)
    }
}
