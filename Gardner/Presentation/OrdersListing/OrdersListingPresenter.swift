//
//  ScheduleListingPresenter.swift
//  Gardner
//
//  Created by Rashid Khan on 13/05/2023.
//

import Foundation

protocol OrderListingPresenterType {
    func fetchPendingServiceRequests()
    func updateRequestStatus(requestId: String, status: ServiceRequestStatus)
}

protocol OrdersListingPresenterOutput: AnyObject, LoadingOutputs {
    func ordersListingPresenter(pendingRequestsFetchingSuccess requests: [ServiceRequest])
    func ordersListingPresenter(pendingRequestsFetchingFailure message: String)
    func ordersListingPresenter(requestStatusUpdated requestId: String)
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
    func fetchPendingServiceRequests() {
        self.outputs?.startLoading()
        
        self.service.getServiceRequest { result in
            self.outputs?.stopLoading()
            
            switch result {
            case .success(let requests):
                let pendingRequests = requests.filter {
                    $0.status == .pending
                }
                
                self.outputs?.ordersListingPresenter(pendingRequestsFetchingSuccess: pendingRequests)
                break
                
            case .failure(let error):
                let errorMessage = error.errorDescription ?? error.localizedDescription
                self.outputs?.ordersListingPresenter(pendingRequestsFetchingFailure: errorMessage)
                break
            }
        }
    }
    
    func updateRequestStatus(requestId: String, status: ServiceRequestStatus) {
        self.outputs?.startLoading()
        
        self.service.updateStatus(requestId: requestId, status: status) { result in
            self.outputs?.stopLoading()
            
            switch result {
                
            case .success(_):
                self.outputs?.ordersListingPresenter(requestStatusUpdated: requestId)
                
            case .failure(let error):
                let errorMessage = error.errorDescription ?? error.localizedDescription
                self.outputs?.ordersListingPresenter(pendingRequestsFetchingFailure: errorMessage)
            }
        }
    }
}
