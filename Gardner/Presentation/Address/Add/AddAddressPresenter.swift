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
}

protocol AddressAddPresenterOutput: AnyObject {
    func addressAddPresenter(addressValidationError validationError: FieldValidationError)
    func addressAddPresenter(addressAdded address: Address)
    func addressAddPresenter(addressAddingFailed message: String)
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
        
        let instructions = "\(streetName), \(buildingName), \(area)"
        
        let address = AddressAdd(title: title, area: area, streetName: streetName, buildingName: buildingName, city: city, instructions: instructions)
        
        self.service.addAddress(address: address) { result in
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
}
