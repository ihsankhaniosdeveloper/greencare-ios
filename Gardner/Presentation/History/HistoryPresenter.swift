//
//  HistoryPresenter.swift
//  Gardner
//
//  Created by Rashid Khan on 17/06/2023.
//

import Foundation

protocol HistoryPresenterType {
    func fetchServiceRequest()
}

protocol HistoryPresenterOutput: AnyObject, LoadingOutputs {
    func historyPresenter(serviceRequestFetchSuccess serviceRequests: [ServiceRequest])
    func historyPresenter(serviceRequestFetchFailed message: String)
}

class HistoryPresenter: HistoryPresenterType {
    private var service: ServiceRequestServiceType
    weak var outputs: HistoryPresenterOutput?
    
    init(service: ServiceRequestServiceType) {
        self.service = service
    }
    
    func fetchServiceRequest() {
        self.outputs?.startLoading()
        
        self.service.getServiceRequest { result in
            self.outputs?.stopLoading()
            
            switch result {
                
            case .success(let serviceRequests):
                let filtered = serviceRequests.filter { $0.status == .completed }
                self.outputs?.historyPresenter(serviceRequestFetchSuccess: filtered)
                
            case .failure(let error):
                self.outputs?.historyPresenter(serviceRequestFetchFailed: error.errorDescription ?? error.localizedDescription)
            }
        }
    }
}
