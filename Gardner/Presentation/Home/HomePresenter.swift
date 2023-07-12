//
//  HomePresenter.swift
//  Gardner
//
//  Created by Rashid Khan on 07/05/2023.
//

import Foundation

protocol HomePresenterType {
    func fetchServiceRequest()
    func fetchUserProfile()
}

protocol HomePresenterOutput: AnyObject, LoadingOutputs {
    func homePresenter(serviceRequestsFetchingSuccess serviceRequests: [ServiceRequest])
    func homePresenter(userProfileFetchingSuccess profile: UserProfile)
    func homePresenter(serviceRequestsFetchingFail message: String)
}

class HomePresenter: HomePresenterType {
    weak var outputs: HomePresenterOutput?
    
    private var requestsService: ServiceRequestServiceType
    private var userService: AuthenticationServiceType
    
    init(requestsService: ServiceRequestServiceType, userService: AuthenticationServiceType) {
        self.requestsService = requestsService
        self.userService = userService
    }
    
    func fetchServiceRequest() {
        self.outputs?.startLoading()
        self.requestsService.getServiceRequest { result in
            self.outputs?.stopLoading()
            
            switch result {
                
            case .success(let serviceRequests):
                let filtered = serviceRequests.filter {
                    $0.status == .accepted || $0.status == .inProgress
                }
                
                self.outputs?.homePresenter(serviceRequestsFetchingSuccess: filtered)
                break
                
            case .failure(let error):
                self.outputs?.homePresenter(serviceRequestsFetchingFail: error.errorDescription ?? error.localizedDescription)
                break
            }
        }
    }
    
    func fetchUserProfile() {
        if let userProfile = UserSession.instance.profile {
            self.outputs?.homePresenter(userProfileFetchingSuccess: userProfile)
            return
        }
        
        self.userService.getUser { result in
            switch result {
                
            case .success(let profile):
                UserSession.instance.profile = profile
                self.outputs?.homePresenter(userProfileFetchingSuccess: profile)
                
            case .failure:
                break
            }
        }
    }
}
