//
//  ScheduleListingPresenter.swift
//  Gardner
//
//  Created by Rashid Khan on 13/05/2023.
//

import Foundation

protocol ScheduleListingPresenterType {
    func fetchScheduleSlots()
}

protocol ScheduleListingPresenterOutput: AnyObject {
    func scheduleListingPresenter(scheduleOrderFetchSuccess requests: [ServiceRequest])
    func scheduleListingPresenter(scheduleOrderFetchFailed message: String)
}

class ScheduleListingPresenter {
    func scheduleListingPresenter() {
        
    }
    
    private var service: ServiceRequestServiceType
    
    weak var outputs: ScheduleListingPresenterOutput?
    
    init(service: ServiceRequestServiceType) {
        self.service = service
    }
}

extension ScheduleListingPresenter: ScheduleListingPresenterType {
    func fetchScheduleSlots() {
        self.service.getServiceRequest { result in
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
