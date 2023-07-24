//
//  ServiceRequestService.swift
//  Gardner
//
//  Created by Rashid Khan on 17/06/2023.
//

import Foundation

// MARK: - Service Type
protocol ServiceRequestServiceType {
    func getServiceRequest(completion: @escaping CompletionClosure<[ServiceRequest]>)
    func create(params: ServiceRequestParams, completion: @escaping CompletionClosure<Bool>)
}

// MARK: - Service Implementation
class ServiceRequestService: BaseService, ServiceRequestServiceType {
    func create(params: ServiceRequestParams, completion: @escaping CompletionClosure<Bool>) {
        let route = ServiceRequestAPIRoutes.create(serviceRequestParams: params)
        
        self.request(route: route) { (data: EmptyResonseDecodable?, error: NetworkErrors?) in
            if let _ = data, error == nil {
                completion(.success(true))
                return
            }
            
            completion(.failure(error ?? .unknown))
        }
    }
    
    func getServiceRequest(completion: @escaping CompletionClosure<[ServiceRequest]>) {
        self.request(route: ServiceRequestAPIRoutes.getAll) { (data: ServiceRequestsResponse?, error: NetworkErrors?) in
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

// MARK: - Routes
fileprivate enum ServiceRequestAPIRoutes {
    case getAll
    case create(serviceRequestParams: ServiceRequestParams)
}

extension ServiceRequestAPIRoutes: APIRouteType {
    var path: String {
        switch self {
        case .getAll, .create: return "v1/servicerequest"
        }
    }
    
    var method: HTTPRequestMethod {
        switch self {
            case .getAll: return .get
            case .create: return .post
        }
    }
    
    var body: [String : Any]? {
        switch self {
            case .getAll: return nil
            case .create(let serviceRequestParams): return serviceRequestParams.dict
        }
    }
}
