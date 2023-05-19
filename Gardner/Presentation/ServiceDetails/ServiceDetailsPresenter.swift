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
protocol ServiceDetailsPresenterOutput: AnyObject {
    func serviceDetailsPresenter(updatedService: Service)
}

protocol ServiceDetailsPresenterType {
    func getServiceDetails()
}

class ServiceDetailsPresenter: ServiceDetailsPresenterType {
    private var service: ServicesServiceType
    private var serviceEntity: Service
    
    weak var outputs: ServiceDetailsPresenterOutput?
    
    init(service: ServicesServiceType, serviceEntity: Service) {
        self.service = service
        self.serviceEntity = serviceEntity
    }
    
    func getServiceDetails() {
        self.outputs?.serviceDetailsPresenter(updatedService: self.serviceEntity)
    }
}
