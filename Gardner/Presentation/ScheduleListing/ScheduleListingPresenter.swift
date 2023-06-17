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
    func scheduleListingPresenter(scheduleOrderFetchSuccess services: [Service])
}

class ScheduleListingPresenter {
    func scheduleListingPresenter() {
        
    }
    
    private var service: ServicesServiceType
    
    weak var outputs: ScheduleListingPresenterOutput?
    
    init(service: ServicesServiceType) {
        self.service = service
    }
}

extension ScheduleListingPresenter: ScheduleListingPresenterType {
    func fetchScheduleSlots() {
        
    }
}
