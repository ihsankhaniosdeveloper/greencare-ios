//
//  HistoryPresenter.swift
//  Gardner
//
//  Created by Rashid Khan on 17/06/2023.
//

import Foundation

protocol HistoryPresenterType {
    func fetchServiceRequest(_for status: ServiceRequestStatus)
}

protocol HistoryPresenterOutput: AnyObject {
    func historyPresenter(serviceRequestFetchSuccess serviceRequests: [ServiceRequest])
    func historyPresenter(serviceRequestFetchFailed message: String)
}

class HistoryPresenter: HistoryPresenterType {
    private var service: ServiceRequestServiceType
    
    private var requests: [ServiceRequest] = []
    weak var outputs: HistoryPresenterOutput?
    
    init(service: ServiceRequestServiceType) {
        self.service = service
    }
    
    func fetchServiceRequest(_for status: ServiceRequestStatus) {
        if !self.requests.isEmpty {
            let filteredSR = self.requests.filter { $0.status == status }
            self.outputs?.historyPresenter(serviceRequestFetchSuccess: filteredSR)
            return
        }
        
        self.service.getServiceRequest { result in
            switch result {
                
            case .success(let serviceRequests):
                self.requests = serviceRequests
                let filteredSR = serviceRequests.filter { $0.status == status }
                self.outputs?.historyPresenter(serviceRequestFetchSuccess: filteredSR)
                
            case .failure(let error):
                self.outputs?.historyPresenter(serviceRequestFetchFailed: error.errorDescription ?? error.localizedDescription)
            }
        }
    }
}
