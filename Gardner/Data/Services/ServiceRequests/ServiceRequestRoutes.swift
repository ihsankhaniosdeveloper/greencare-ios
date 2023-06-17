//
//  ServiceRequestRoutes.swift
//  Gardner
//
//  Created by Rashid Khan on 17/06/2023.
//

import Foundation

enum ServiceRequestAPIRoutes {
    case getAllServiceRequest
}

extension ServiceRequestAPIRoutes: APIRouteType {
    var path: String {
        switch self {
            case .getAllServiceRequest: return "v1/servicerequest"
        }
    }
    
    var method: HTTPRequestMethod {
        switch self {
            case .getAllServiceRequest: return .get
        }
    }
    
    
}
