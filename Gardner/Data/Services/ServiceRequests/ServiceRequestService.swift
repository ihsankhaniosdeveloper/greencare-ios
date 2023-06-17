//
//  ServiceRequestService.swift
//  Gardner
//
//  Created by Rashid Khan on 17/06/2023.
//

import Foundation

protocol ServiceRequestServiceType {
    func getServiceRequest(completion: @escaping CompletionClosure<[ServiceRequest]>)
}

class ServiceRequestService: BaseService, ServiceRequestServiceType {
    func getServiceRequest(completion: @escaping CompletionClosure<[ServiceRequest]>) {
        self.request(route: ServiceRequestAPIRoutes.getAllServiceRequest) { (data: ServiceRequestsResponse?, error: NetworkErrors?) in
            if let data = data, error == nil {
                completion(.success(data.serviceRequests))
                return
            }
            
            completion(.failure(error ?? .unknown))
        }
        
        struct ServiceRequestsResponse: Codable {
            let serviceRequests: [ServiceRequest]
        }
    }
}
