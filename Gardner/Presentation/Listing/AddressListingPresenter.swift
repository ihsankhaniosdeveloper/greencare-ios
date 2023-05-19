//
//  AddressListViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 19/05/2023.
//

import Foundation

protocol AddressListingPresenterType {
    
}

protocol AddressListingPresenterOutput {
    
}

class AddressListingPresenter: AddressListingPresenterType {
    private var service: AddressServiceType
    
    init(service: AddressServiceType) {
        self.service = service
    }
}
