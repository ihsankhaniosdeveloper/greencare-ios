//
//  CartPresenter.swift
//  Gardner
//
//  Created by Rashid Khan on 07/06/2023.
//

import Foundation

protocol CartPresenterType {
    func requestService(serviceId: String, addressId: String, selectedSlots: [Slot])
}

protocol CartPresenterOutput: AnyObject {
    
}

class CartPresenter: CartPresenterType {
    private var service: ServicesServiceType
    
    weak var outputs: CartPresenterOutput?
    
    init(service: ServicesServiceType) {
        self.service = service
    }
    
    func requestService(serviceId: String, addressId: String, selectedSlots: [Slot]) {
        let params = ServiceRequestParams(service: serviceId, address: addressId, paymentMethod: .cash, slots: selectedSlots)
        
        self.service.requestService(params: params) { result in
            switch result {
                
            case .success(let isSuccess):
                break
                
            case .failure(let error):
                
                break
            }
        }
    }
    
}
