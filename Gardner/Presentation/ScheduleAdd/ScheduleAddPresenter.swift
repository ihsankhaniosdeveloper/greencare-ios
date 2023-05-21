//
//  ScheduleAddPresenter.swift
//  Gardner
//
//  Created by Rashid Khan on 12/05/2023.
//

import Foundation

protocol ScheduleAddPresenterOutput: AnyObject {
    func scheduleAddPresenter(scheduleRequestSuccess requestServiceResponse: RequestServiceResponse)
    func scheduleAddPresenter(scheduleRequestFailed message: String)
}

protocol ScheduleAddPresenterType: AnyObject {
    func requestService(addressId: String?, serviceId: String?, slots: [Slot]?)
}

class ScheduleAddPresenter: ScheduleAddPresenterType {
    private var service: ServicesServiceType
    
    weak var outputs: ScheduleAddPresenterOutput?
    
    init(service: ServicesServiceType) {
        self.service = service
    }
    
    func requestService(addressId: String?, serviceId: String?, slots: [Slot]?) {
        guard let addressId = addressId else { return }
        guard let serviceId = serviceId else { return }
        guard let slots = slots else { return }
        
        self.service.requestService(addressId: addressId, serviceId: serviceId, slots: slots) { result in
            switch result {
                
            case .success(let data):
                self.outputs?.scheduleAddPresenter(scheduleRequestSuccess: data)
                break
                
            case .failure(let error):
                self.outputs?.scheduleAddPresenter(scheduleRequestFailed: error.errorDescription ?? error.localizedDescription)
                break
            }
        }
    }
}
