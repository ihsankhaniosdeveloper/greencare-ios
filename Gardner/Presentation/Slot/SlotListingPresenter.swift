//
//  SlotListingPresenter.swift
//  Gardner
//
//  Created by Rashid Khan on 19/05/2023.
//

import Foundation

struct Slot: Decodable {
    
}

protocol SlotListingPresenterType {
    func getSlots(serviceId: String)
}

protocol SlotListingPresenterOutput {
    func slotPresenter(slotsFetchingSuccess slots: [Slot])
}

class SlotListingPresenter: SlotListingPresenterType {
    private var service: ServicesServiceType
    
    init(service: ServicesServiceType) {
        self.service = service
    }
    
    func getSlots(serviceId: String) {
        
    }
}
