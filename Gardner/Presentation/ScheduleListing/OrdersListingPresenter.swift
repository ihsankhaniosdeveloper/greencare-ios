//
//  ScheduleListingPresenter.swift
//  Gardner
//
//  Created by Rashid Khan on 13/05/2023.
//

import Foundation

protocol OrderListingPresenterType {
    func fetchScheduleSlots()
}

protocol OrdersListingPresenterOutput: AnyObject, LoadingOutputs {
    func scheduleListingPresenter(scheduleOrderFetchSuccess requests: [ServiceRequest])
    func scheduleListingPresenter(scheduleOrderFetchFailed message: String)
}

class OrdersListingPresenter {
    func scheduleListingPresenter() {
        
    }
    
    private var service: ServiceRequestServiceType
    
    weak var outputs: OrdersListingPresenterOutput?
    
    init(service: ServiceRequestServiceType) {
        self.service = service
    }
}

extension OrdersListingPresenter: OrderListingPresenterType {
    func fetchScheduleSlots() {
        self.outputs?.startLoading()
        
        self.service.getServiceRequest { result in
            self.outputs?.stopLoading()
            
            switch result {
                
            case .success(let requests):
                self.outputs?.scheduleListingPresenter(scheduleOrderFetchSuccess: requests)
                break
                
            case .failure(let error):
                self.outputs?.scheduleListingPresenter(scheduleOrderFetchFailed: error.errorDescription ?? error.localizedDescription)
                break
            }
        }
    }
}
