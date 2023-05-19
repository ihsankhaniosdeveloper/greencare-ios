//
//  AddressService.swift
//  Gardner
//
//  Created by Rashid Khan on 19/05/2023.
//

import Foundation

struct AddressResponse: Codable {
    let addresses: [Address]?
}

struct Address: Codable {
    let id, title: String?
    let latitude, longitude: Double?
    let instructions, createdAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, latitude, longitude, instructions, createdAt
        case v = "__v"
    }
}


protocol AddressServiceType {
    func getAddresses(completion: @escaping CompletionClosure<[Address]>)
}

class AddressService: BaseService, AddressServiceType {
    func getAddresses(completion: @escaping CompletionClosure<[Address]>) {
        self.request(route: AddressRoutes.addressAll) { (data: AddressResponse?, error: NetworkErrors?) in
            if let data = data, error == nil {
                completion(.success(data.addresses ?? []))
                return
            }
            
            completion(.failure(error ?? .unknown))
        }
    }
}
