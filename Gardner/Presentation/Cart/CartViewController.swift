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
    
    private var calculateAmoutResponse: CalculateAmountResponse!
//    private var selectedSlots: [Slot] = []
    private var presenter: CartPresenterType!
    
    static func make(presenter: CartPresenterType, calculateAmoutResponse: CalculateAmountResponse) -> CartViewController {
        let vc = CartViewController(nibName: "CartViewController", bundle: .main)
        
        vc.calculateAmoutResponse = calculateAmoutResponse
        vc.presenter = presenter
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (self.presenter as? CartPresenter)?.outputs = self
        
        self.title = "Invoice"
        self.populateData()
    }
    
    
    @IBAction func checkoutButtonTap(_ sender: Any) {
        self.presenter.requestService(paymentMethod: .cash)
    }
}

extension CartViewController: CartPresenterOutput {
    func cartPresenter(serviceRequestSuccess isSuccess: Bool) {
        let orderSuccessVC = ServiceRequestSuccessViewController(nibName: "ServiceRequestSuccessViewController", bundle: .main)
        orderSuccessVC.modalPresentationStyle = .fullScreen
        self.present(orderSuccessVC, animated: true) {
            self.navigationController?.popToRootViewController(animated: false)
        }
    }
    
    func startLoading() {
        self.startActivityIndicator()
    }
    
    func stopLoading() {
        self.stopActivityIndicator()
    }
    
    func cartPresenter(serviceRequestFailed message: String) {
        self.showSnackBar(message: message)
    }
    
}

fileprivate extension CartViewController {
    func populateData() {
        self.ivServiceImage.sd_setImage(with: URL(string: self.calculateAmoutResponse.service?.image ?? ""), placeholderImage: nil, context: nil)
        self.lblTitle.text = self.calculateAmoutResponse.service?.title
        self.lblPrice.text = calculateAmoutResponse.service?.price?.formattedAmountWithAED
        self.lblHours.text = "Hours: \(self.getTotalHours())"
        self.lblPersons.text = "Persons: 2"
        self.lblDate.text = Date().toDateString()
        self.lblSubTotal.text = calculateAmoutResponse.totalPrice.formattedAmountWithAED
        self.lblDeliveryFee.text = calculateAmoutResponse.deliveryFee.formattedAmountWithAED
        self.lblTotal.text = (calculateAmoutResponse.totalPrice + calculateAmoutResponse.deliveryFee).formattedAmountWithAED
    }
    
    func getTotalHours() -> Int {
        var selectedSlotsCount = 0
        
        (self.presenter as! CartPresenter).selectedSlots.forEach { slot in
            selectedSlotsCount += slot.timeSlots.count
        }
        
        return selectedSlotsCount * (self.calculateAmoutResponse.service?.minHours ?? 0)
    }
}

extension Double {
    var formattedAmountWithAED: String {
        return "AED " + String(format: "%.2f", self)
    }
}
