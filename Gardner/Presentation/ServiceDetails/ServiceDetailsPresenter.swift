//
//  ServiceDetailsPresenter.swift
//  Gardner
//
//  Created by Rashid Khan on 11/05/2023.
//

import Foundation

protocol ServiceDetailsPresenterOutput: AnyObject {
    func serviceDetailsPresenter(updatedService: Service)
}

protocol ServiceDetailsPresenterType {
    func loadDefaultData()
}

class ServiceDetailsPresenter: ServiceDetailsPresenterType {
    private var apiClient: APIClientType
    private var service: Service
    
    weak var outputs: ServiceDetailsPresenterOutput?
    
    init(apiClient: APIClientType, service: Service) {
        self.apiClient = apiClient
        self.service = service
    }
    
    func loadDefaultData() {
        self.outputs?.serviceDetailsPresenter(updatedService: self.service)
    }
}
