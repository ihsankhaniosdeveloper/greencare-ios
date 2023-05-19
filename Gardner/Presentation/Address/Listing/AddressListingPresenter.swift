//
//  AddressListViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 19/05/2023.
//

import Foundation

protocol AddressListingPresenterType {
    func getAllAddresses()
}

protocol AddressListingPresenterOutput: AnyObject {
    func addressListingPresenter(addressesFetchingSuccess addresses: [Address])
    func addressListingPresenter(addressesFetchingFailed message: String)
}

class AddressListingPresenter: AddressListingPresenterType {
    private var service: AddressServiceType
    
    weak var outputs: AddressListingPresenterOutput?
    
    init(service: AddressServiceType) {
        self.service = service
    }
    
    func getAllAddresses() {
        self.service.getAddresses { result in
            switch result {
                
            case .success(let addresses):
                self.outputs?.addressListingPresenter(addressesFetchingSuccess: addresses)
                break
                
            case .failure(let error):
                self.outputs?.addressListingPresenter(addressesFetchingFailed: error.localizedDescription)
                break
            }
        }
    }
}
