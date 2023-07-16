//
//  ServiceDetailsPresenter.swift
//  Gardner
//
//  Created by Rashid Khan on 11/05/2023.
//

import Foundation

struct ServiceResponse: Decodable {
    let service: Service
}
protocol ServiceRequestDetailsPresenterOutput: AnyObject, LoadingOutputs {
    func serviceRequestDetailsPresenter(statusUpdatedSuccess updatedStatus: ServiceRequestStatus)
    func serviceRequestDetailsPresenter(statusUpdatedFailed message: String)
}

protocol ServiceRequestDetailsPresenterType {
    func updateServiceRequestStatus(requestId: String, currentStatus: ServiceRequestStatus)
}

class ServiceRequestDetailsPresenter: ServiceRequestDetailsPresenterType {
    private var service: ServiceRequestServiceType
    
    weak var outputs: ServiceRequestDetailsPresenterOutput?
    
    init(service: ServiceRequestServiceType) {
        self.service = service
    }
    
    func updateServiceRequestStatus(requestId: String, currentStatus: ServiceRequestStatus) {
        if currentStatus == .completed { return }
        
        self.outputs?.startLoading()
        let updatedStatus: ServiceRequestStatus = currentStatus == .accepted ? .inProgress : .completed
        self.service.updateStatus(requestId: requestId, status: updatedStatus) { result in
            self.outputs?.stopLoading()
            
            switch result {
                
            case .success:
                self.outputs?.serviceRequestDetailsPresenter(statusUpdatedSuccess: updatedStatus)
                break
                
            case .failure(let error):
                self.outputs?.serviceRequestDetailsPresenter(statusUpdatedFailed: error.errorDescription ?? error.localizedDescription)
                break
            }
        }
    }
}
