//
//  AddressRoutes.swift
//  Gardner
//
//  Created by Rashid Khan on 19/05/2023.
//

import Foundation

enum AddressRoutes {
    case addressAll
    case addAddress(address: AddressAdd)
}

extension AddressRoutes: APIRouteType {
    var path: String {
        switch self {
            case .addressAll: return "v1/address/get"
            case .addAddress: return "v1/address"
        }
    }
    
    var method: HTTPRequestMethod {
        switch self {
            case .addressAll: return .get
            case .addAddress: return .post
        }
    }
    
    var body: [String : Any]? {
        switch self {
            case .addressAll: return nil
            case .addAddress(let address): return address.dict
        }
    }
}

extension Encodable {
    var dict : [String: Any]? {
        let encoder = JSONEncoder()
        
        encoder.dateEncodingStrategy = .formatted(serverReadableDateTimeFormatter)
        guard let data = try? encoder.encode(self) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return nil }
        return json
    }
    
    private var serverReadableDateTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }
}
