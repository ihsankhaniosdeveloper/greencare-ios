//
//  AddAddressPresenter.swift
//  Gardner
//
//  Created by Rashid Khan on 19/05/2023.
//

import Foundation

enum FieldValidationError {
    case title
    case area
    case streetName
    case buildingName
}

protocol AddressAddPresenterType {
    func addAddress(title: String?, area: String?, streetName: String?, buildingName: String?, city: String?)
    func updateAddress(address: Address)
}

enum Operation {
    case updateAddress, deleteAddress
}

protocol AddressAddPresenterOutput: AnyObject, LoadingOutputs {
    func addressAddPresenter(addressValidationError validationError: FieldValidationError)
    func addressAddPresenter(addressAdded address: Address)
    func addressAddPresenter(addressAddingFailed message: String)
    func addressPresenter(addressUpdated message: String)
}

class AddressAddPresenter: AddressAddPresenterType {
    private var service: AddressServiceType
    
    weak var outputs: AddressAddPresenterOutput?
    
    init(service: AddressServiceType) {
        self.service = service
    }
    
    func addAddress(title: String?, area: String?, streetName: String?, buildingName: String?, city: String?) {
        guard let title = title, title.count != 0 else {
            outputs?.addressAddPresenter(addressValidationError: .title)
            return
        }
        
        guard let area = area, area.count != 0 else {
            outputs?.addressAddPresenter(addressValidationError: .area)
            return
        }
        
        guard let streetName = streetName, streetName.count != 0 else {
            outputs?.addressAddPresenter(addressValidationError: .streetName)
            return
        }
        
        guard let buildingName = buildingName, buildingName.count != 0 else {
            outputs?.addressAddPresenter(addressValidationError: .buildingName)
            return
        }
        
        let instructions = title
        
        let address = AddressAdd(title: title, area: area, streetName: streetName, buildingName: buildingName, city: city, instructions: instructions)
        
        self.outputs?.startLoading()
        
        self.service.addAddress(address: address) { result in
            
            self.outputs?.stopLoading()
            
            switch result {
                
            case .success(let address):
                self.outputs?.addressAddPresenter(addressAdded: address)
                break
                
            case .failure(let error):
                self.outputs?.addressAddPresenter(addressAddingFailed: error.localizedDescription)
                break
                
            }
        }
        
    }
    
    func updateAddress(address: Address) {
        self.outputs?.startLoading()
        
        self.service.update(address: address) { result in
            
            self.outputs?.stopLoading()
            
            switch result {
                
            case .success(_):
                self.outputs?.addressPresenter(addressUpdated: "")
                break
                
            case .failure(let error):
                self.outputs?.addressAddPresenter(addressAddingFailed: error.errorDescription ?? error.localizedDescription)
                break
            }
        }
    }
}
