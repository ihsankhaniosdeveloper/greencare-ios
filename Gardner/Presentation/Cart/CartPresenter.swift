//
//  CartPresenter.swift
//  Gardner
//
//  Created by Rashid Khan on 07/06/2023.
//

import Foundation

struct Constatns {
    static let stripePublishableKey = "pk_test_51NVr3fFUqtvM9iCfv1fhHeAmtV3VrNecb909M2xvM7SuhdPR7xdDVJwZrTTU0SPKkSfYnL6uYMqtLmOBgGXNlcb500ehKIVkR3"
}

protocol CartPresenterType {
    func requestService(paymentMethod: PaymentMethod)
    func getPaymentIntent(serviceRequestId: String, amount: Double)
}

protocol CartPresenterOutput: AnyObject, LoadingOutputs {
    func cartPresenter(serviceRequestSuccess isSuccess: Bool)
    func cartPresenter(operationFailed message: String)
    func cartPresenter(paymentIntentFetchSuccess paymentIntent: PaymentIntent)
}

class CartPresenter: CartPresenterType {
    func getPaymentIntent(serviceRequestId: String, amount: Double) {
        self.outputs?.startLoading()
        
        self.paymentService.createPaymentIntent(amount: amount, serviceRequestId: serviceRequestId) { result in
            self.outputs?.stopLoading()
            
            switch result {
                    
            case .success(let paymentIntent):
                self.outputs?.cartPresenter(paymentIntentFetchSuccess: paymentIntent)
                break
                
            case .failure(let error):
                self.outputs?.cartPresenter(operationFailed: error.errorDescription ?? error.localizedDescription)
                break
            }
        }
    }
    
    private var service: ServicesServiceType
    private var paymentService: PaymentServiceType
    
    private var selectedServiceId: String
    private var selectedAddressId: String
    var selectedSlots: [Slot]
    
    weak var outputs: CartPresenterOutput?
    
    init(service: ServicesServiceType, selectedSlots: [Slot], paymentService: PaymentServiceType, selectedServiceId: String, selectedAddressId: String) {
        self.service = service
        self.paymentService = paymentService
        
        self.selectedServiceId = selectedServiceId
        self.selectedAddressId = selectedAddressId
        self.selectedSlots = selectedSlots
    }
    
    func requestService(paymentMethod: PaymentMethod) {
        let params = ServiceRequestParams(
            service: self.selectedServiceId,
            address: self.selectedAddressId,
            paymentMethod: paymentMethod,
            slots: self.selectedSlots
        )
        
        self.outputs?.startLoading()
        self.service.requestService(params: params) { result in
            self.outputs?.stopLoading()
            
            switch result {
                
            case .success(let isSuccess):
                self.outputs?.cartPresenter(serviceRequestSuccess: isSuccess)
                break
                
            case .failure(let error):
                self.outputs?.cartPresenter(operationFailed: error.errorDescription ?? error.localizedDescription)
                break
            }
        }
    }
    
}
