//
//  ScheduleAddPresenter.swift
//  Gardner
//
//  Created by Rashid Khan on 12/05/2023.
//

import Foundation

protocol ScheduleAddPresenterOutput: AnyObject {
    func scheduleAddPresenter(scheduleRequestSuccess requestServiceResponse: ServiceRequest)
    func scheduleAddPresenter(scheduleRequestFailed message: String)
    func scheduleAddPresenter(scheduleRequestValidationFailed message: String)
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
        guard let addressId = addressId else {
            self.outputs?.scheduleAddPresenter(scheduleRequestValidationFailed: "Address is required, please select address and then continue.")
            return
        }
        guard let serviceId = serviceId else { return }
        guard let slots = slots else {
            self.outputs?.scheduleAddPresenter(scheduleRequestValidationFailed: "Slots required, please select slots and then continue.")
            return
        }
        
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
