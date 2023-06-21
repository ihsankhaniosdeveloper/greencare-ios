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
    case update(address: Address)
    case delete(addressId: String)
}

extension AddressRoutes: APIRouteType {
    var path: String {
        switch self {
            case .addressAll: return "v1/address/get"
            case .addAddress: return "v1/address"
            case .update: return "v1/address/update"
            case .delete: return "v1/address/delete"
        }
    }
    
    var method: HTTPRequestMethod {
        switch self {
            case .addressAll: return .get
            case .addAddress, .delete, .update: return .post
        }
    }
    
    var body: [String : Any]? {
        switch self {
            case .addressAll: return nil
            case .addAddress(let address): return address.dict
            case .update(let address): return address.dict
            case .delete(let addressId): return ["addressId": addressId]
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
