//
//  SlotListingPresenter.swift
//  Gardner
//
//  Created by Rashid Khan on 19/05/2023.
//

import Foundation

//protocol SlotListingPresenterType {
//    func getSlots(serviceId: String)
//}
//
//protocol SlotListingPresenterOutput: AnyObject {
//    func slotPresenter(slotsFetchingSuccess slots: [Slot])
//    func slotPresenter(slotsFetchingFailed message: String)
//}
//
//class SlotListingPresenter: SlotListingPresenterType {
//    private var service: SlotServiceType
//    
//    weak var outputs: SlotListingPresenterOutput?
//    
//    init(service: SlotServiceType) {
//        self.service = service
//    }
//    
//    func getSlots(serviceId: String) {
//        self.service.getSlots(serviceType: serviceId) { result in
//            switch result {
//                
//            case .success(let slots):
//                self.outputs?.slotPresenter(slotsFetchingSuccess: slots)
//                break
//                
//            case .failure(let error):
//                self.outputs?.slotPresenter(slotsFetchingFailed: error.errorDescription ?? error.localizedDescription)
//                break
//            }
//        }
//    }
//}
