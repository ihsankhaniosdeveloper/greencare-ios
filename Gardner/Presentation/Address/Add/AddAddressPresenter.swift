//
//  AddAddressPresenter.swift
//  Gardner
//
//  Created by Rashid Khan on 19/05/2023.
//

import Foundation

protocol AddressAddPresenterType {
    func addAddress(area: String?, streetName: String?, buildingName: String?)
}

protocol AddressAddPresenterOutput: AnyObject {

}

class AddressAddPresenter: AddressAddPresenterType {
    private var service: AddressServiceType
    
    weak var outputs: AddressAddPresenterOutput?
    
    init(service: AddressServiceType) {
        self.service = service
    }
    
    func addAddress(area: String?, streetName: String?, buildingName: String?) {
        
    }
}
