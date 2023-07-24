//
//  CartViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 13/05/2023.
//

import UIKit
import StripePaymentSheet
import SDWebImage

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
    
    @IBOutlet weak var switchCOD: UISwitch!
    @IBOutlet weak var switchPayUsingCard: UISwitch!
    
    private var calculateAmoutResponse: CalculateAmountResponse!
    private var presenter: CartPresenterType!
    private var selectedPaymentMethod: PaymentMethod?
    
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
        guard let selectedPaymentMethod = self.selectedPaymentMethod else {
            self.showSnackBar(message: "Please select payment method and then continue")
            return
        }
        
        switch selectedPaymentMethod {
            
        case .cash:
            self.presenter.requestService(paymentMethod: .cash)
        case .card:
            let totalAmount = self.calculateAmoutResponse.totalPrice + self.calculateAmoutResponse.deliveryFee
            self.presenter.getPaymentIntent(amount: totalAmount)
        }
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        switch sender {
            case switchCOD:
                switchPayUsingCard.isOn = false
                self.selectedPaymentMethod = .cash
            
            case switchPayUsingCard:
                switchCOD.isOn = false
                self.selectedPaymentMethod = .card
            
            default:break
        }
    }
    
    private func showStipePaymentSheet(with _clientSecret: String) {
        STPAPIClient.shared.publishableKey = Constatns.stripePublishableKey
        var configuration = PaymentSheet.Configuration()
        configuration.merchantDisplayName = "Green Care"
//        configuration.customer = .init(id: UserSession.instance.profile, ephemeralKeySecret: customerEphemeralKeySecret)
        configuration.allowsDelayedPaymentMethods = true
        let paymentSheet = PaymentSheet(paymentIntentClientSecret: _clientSecret, configuration: configuration)

        
        paymentSheet.present(from: self) { result in
            switch result {
                
            case .completed:
                self.presenter.requestService(paymentMethod: .card)
                break
                
            case .canceled:
                break
                
            case .failed(let error):
                self.showSnackBar(message: error.localizedDescription)
                break
            }
        }
    }
}

extension CartViewController: CartPresenterOutput {
    func cartPresenter(paymentIntentFetchSuccess paymentIntent: PaymentIntent) {
        self.showStipePaymentSheet(with: paymentIntent.clientSecret)
    }
    
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
    
    func cartPresenter(operationFailed message: String) {
        self.showSnackBar(message: message)
    }
    
}

fileprivate extension CartViewController {
    func populateData() {
        self.ivServiceImage.sd_setImage(with: URL(string: self.calculateAmoutResponse.service?.image ?? ""), placeholderImage: UIImage(named: "profile_placeholder"), options: SDWebImageOptions(rawValue: 7))
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
