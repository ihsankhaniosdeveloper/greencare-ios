//
//  ServiceEntityRoutes.swift
//  Gardner
//
//  Created by Rashid Khan on 28/05/2023.
//

import Foundation

enum ServicesAPIRoutes {
    case services
    case service(serviceId: String)
    case calculateAmount(addressId: String, serviceId: String, slots: [Slot])
    case slots(serviceId: String, serviceType: String)
    case serviceRequest(serviceRequestParams: ServiceRequestParams)
}

extension ServicesAPIRoutes: APIRouteType {
    var path: String {
        switch self {
            case .services: return "v1/service"
            case .service: return "v1/service"
            case .slots: return "v1/slots"
            case .calculateAmount: return "v1/servicerequest/calculate-amount"
            case .serviceRequest: return "v1/servicerequest"
        }
    }
    
    var pathVariables: [String]? {
        switch self {
            case .services, .slots, .calculateAmount, .serviceRequest: return nil
            case .service(serviceId: let serviceId): return [serviceId]
        }
    }
    
    var method: HTTPRequestMethod {
        switch self {
            case .services, .service: return .get
            case .slots, .calculateAmount, .serviceRequest: return .post
        }
    }
    
    var body: [String : Any]? {
        switch self {
            case .services, .service:
                return nil
            
            case .calculateAmount(let addressId, let serviceId, let slots):
                return ServiceAdd(service: serviceId, address: addressId, slots: slots).dict
            
            case .slots(let serviceId, let serviceType):
                return ["serviceType": serviceType, "serviceId": serviceId]
            
            case .serviceRequest(let serviceRequestParams):
                return serviceRequestParams.dict
        }
    }
}
