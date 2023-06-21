//
//  AddressListViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 19/05/2023.
//

import Foundation

protocol AddressListingPresenterType {
    func getAllAddresses()
    func deleteAddress(addressId: String)
}

protocol AddressListingPresenterOutput: AnyObject, LoadingOutputs {
    func addressListingPresenter(addressesFetchingSuccess addresses: [Address])
    func addressListingPresenter(addressesFetchingFailed message: String)
    func addressListingPresenter(addressesDeleteSuccess message: String)
}

class AddressListingPresenter: AddressListingPresenterType {
    private var service: AddressServiceType
    
    weak var outputs: AddressListingPresenterOutput?
    
    init(service: AddressServiceType) {
        self.service = service
    }
    
    func getAllAddresses() {
        self.outputs?.startLoading()
        
        self.service.getAddresses { result in
            
            self.outputs?.stopLoading()
            
            switch result {
                
            case .success(let addresses):
                self.outputs?.addressListingPresenter(addressesFetchingSuccess: addresses)
                break
                
            case .failure(let error):
                self.outputs?.addressListingPresenter(addressesFetchingFailed: error.errorDescription ?? error.localizedDescription)
                break
            }
        }
    }
    
    func deleteAddress(addressId: String) {
        self.outputs?.startLoading()
        
        self.service.delete(addressId: addressId) { result in
            
            self.outputs?.stopLoading()
            
            switch result {

            case .success(_):
                self.outputs?.addressListingPresenter(addressesDeleteSuccess: "")

            case .failure(let error):
                self.outputs?.addressListingPresenter(addressesFetchingFailed: error.errorDescription ?? error.localizedDescription)
            }
        }
    }
}
