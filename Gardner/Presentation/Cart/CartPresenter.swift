//
//  CartPresenter.swift
//  Gardner
//
//  Created by Rashid Khan on 07/06/2023.
//

import Foundation

protocol CartPresenterType {
    func requestService(paymentMethod: PaymentMethod)
}

protocol CartPresenterOutput: AnyObject {
    func cartPresenter(serviceRequestSuccess isSuccess: Bool)
    func cartPresenter(serviceRequestFailed message: String)
}

class CartPresenter: CartPresenterType {
    private var service: ServicesServiceType
    
    private var selectedServiceId: String
    private var selectedAddressId: String
    var selectedSlots: [Slot]
    
    weak var outputs: CartPresenterOutput?
    
    init(service: ServicesServiceType, selectedSlots: [Slot], selectedServiceId: String, selectedAddressId: String) {
        self.service = service
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
        
        self.service.requestService(params: params) { result in
            switch result {
                
            case .success(let isSuccess):
                self.outputs?.cartPresenter(serviceRequestSuccess: isSuccess)
                break
                
            case .failure(let error):
                self.outputs?.cartPresenter(serviceRequestFailed: error.errorDescription ?? error.localizedDescription)
                break
            }
        }
    }
    
}
