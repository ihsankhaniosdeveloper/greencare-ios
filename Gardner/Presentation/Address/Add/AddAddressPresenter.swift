//
//  AddAddressPresenter.swift
//  Gardner
//
//  Created by Rashid Khan on 19/05/2023.
//

import Foundation

protocol AddressAddPresenterType {
}

protocol AddressAddPresenterOutput: AnyObject {

}

class AddressAddPresenter: AddressAddPresenterType {
    private var service: AddressServiceType
    
    weak var outputs: AddressListingPresenterOutput?
    
    init(service: AddressServiceType) {
        self.service = service
    }
}
