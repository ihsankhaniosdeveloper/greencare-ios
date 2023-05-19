//
//  AddressRoutes.swift
//  Gardner
//
//  Created by Rashid Khan on 19/05/2023.
//

import Foundation

enum AddressRoutes {
    case addressAll
}

extension AddressRoutes: APIRouteType {
    var path: String {
        switch self {
            case .addressAll: return "v1/address/get"
        }
    }
    
    var method: HTTPRequestMethod {
        switch self {
            case .addressAll: return .get
        }
    }
    
}
