//
//  ScheduleAddPresenter.swift
//  Gardner
//
//  Created by Rashid Khan on 12/05/2023.
//

import Foundation

protocol ScheduleAddPresenterOutput: AnyObject, LoadingOutputs {
    func scheduleAddPresenter(scheduleRequestSuccess requestServiceResponse: CalculateAmountResponse)
    func scheduleAddPresenter(operationFailed message: String)
    func scheduleAddPresenter(scheduleRequestValidationFailed message: String)
    func scheduleAddPresenter(slotsFetchingSuccess slots: [Slot])
}

protocol ScheduleAddPresenterType: AnyObject {
    func calculateAmount(addressId: String?, serviceId: String?, slots: [Slot]?)
    func getServiceSlots(serviceId: String?, serviceType: String?)
}

class ScheduleAddPresenter: ScheduleAddPresenterType {
    private var service: ServicesServiceType
    
    weak var outputs: ScheduleAddPresenterOutput?
    
    init(service: ServicesServiceType) {
        self.service = service
    }
    
    func calculateAmount(addressId: String?, serviceId: String?, slots: [Slot]?) {
        guard let addressId = addressId else {
            self.outputs?.scheduleAddPresenter(scheduleRequestValidationFailed: "Address is required, please select address and then continue.")
            return
        }
        guard let serviceId = serviceId else { return }
        guard let slots = slots else {
            self.outputs?.scheduleAddPresenter(scheduleRequestValidationFailed: "Slots required, please select slots and then continue.")
            return
        }
        
        var sortedSlots: [Slot] = []
        
        let sortedByDate: [Slot] = slots.sorted { $0.date < $1.date }
        sortedByDate.forEach { slot in
            sortedSlots.append(Slot(date: slot.date, timeSlots: slot.timeSlots.sorted { $0 < $1 }))
        }
        
        self.outputs?.startLoading()
        self.service.calculateAmount(addressId: addressId, serviceId: serviceId, slots: sortedSlots) { result in
            
            self.outputs?.stopLoading()
            
            switch result {
                
            case .success(let data):
                self.outputs?.scheduleAddPresenter(scheduleRequestSuccess: data)
                break
                
            case .failure(let error):
                self.outputs?.scheduleAddPresenter(operationFailed: error.errorDescription ?? error.localizedDescription)
                break
            }   
        }
    }
    
    func getServiceSlots(serviceId: String?, serviceType: String?) {
        guard let serviceId = serviceId, let serviceType = serviceType else {
            self.outputs?.scheduleAddPresenter(operationFailed: "Something went wrong please try again...")
            return
        }
        
        self.outputs?.startLoading()
        
        self.service.getSlots(serviceId: serviceId, serviceType: serviceType) { result in
            
            self.outputs?.stopLoading()
            
            switch result {
                
            case .success(let slots):
                self.outputs?.scheduleAddPresenter(slotsFetchingSuccess: slots)
                break
                
            case .failure(let error):
                self.outputs?.scheduleAddPresenter(operationFailed: error.errorDescription ?? error.localizedDescription)
                break
            }
        }
    }
}
