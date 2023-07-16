//
//  ServiceRequestService.swift
//  Gardner
//
//  Created by Rashid Khan on 17/06/2023.
//

import Foundation

//MARK: -- Service Request Service
protocol ServiceRequestServiceType {
    func getServiceRequest(completion: @escaping CompletionClosure<[ServiceRequest]>)
    func updateStatus(requestId: String, status: ServiceRequestStatus, completion: @escaping CompletionClosure<EmptyResonseDecodable>)
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
    
    func updateStatus(requestId: String, status: ServiceRequestStatus, completion: @escaping CompletionClosure<EmptyResonseDecodable>) {
        let route = ServiceRequestAPIRoutes.updateRequest(requestId: requestId, status: status)
                                            
        self.request(route: route) { (data: EmptyResonseDecodable?, error: NetworkErrors?) in
            if let data = data, error == nil {
                completion(.success(data))
                return
            }
            
            completion(.failure(error ?? .unknown))
        }
    }
    
}

//MARK: -- Service Request Routes
enum ServiceRequestAPIRoutes {
    case getAllServiceRequest
    case updateRequest(requestId: String, status: ServiceRequestStatus)
}

extension ServiceRequestAPIRoutes: APIRouteType {
    var path: String {
        switch self {
            case .getAllServiceRequest, .updateRequest: return "v1/servicerequest"
        }
    }
    
    var method: HTTPRequestMethod {
        switch self {
            case .getAllServiceRequest: return .get
            case .updateRequest: return .put
        }
    }
    
    var pathVariables: [String]? {
        switch self {
            case .getAllServiceRequest: return nil
            case .updateRequest(let requestId, let _): return [requestId]
        }
    }
    
    var body: [String : Any]? {
        switch self {
            case .getAllServiceRequest: return nil
            case .updateRequest(let _, let status): return ["status": status.rawValue]
        }
    }
}
