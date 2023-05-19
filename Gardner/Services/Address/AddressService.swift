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

struct AddressAddResponse: Codable {
    let address: Address
}

struct Address: Codable {
    let title, area, streetName, buildingName: String?
    let city, instructions: String?
    let id: String
    let createdAt: Date?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case title, area, streetName, buildingName, city, instructions
        case id = "_id"
        case createdAt
        case v = "__v"
    }
}

struct AddressAdd: Encodable {
    let title: String
    let area: String
    let streetName: String
    let buildingName: String
    let city: String?
    let instructions: String
    
}

protocol AddressServiceType {
    func getAddresses(completion: @escaping CompletionClosure<[Address]>)
    func addAddress(address: AddressAdd, completion: @escaping CompletionClosure<Address>)
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
    
    func addAddress(address: AddressAdd, completion: @escaping CompletionClosure<Address>) {
        let route = AddressRoutes.addAddress(address: address)
        
        self.request(route: route) { (data: AddressAddResponse?, error: NetworkErrors?) in
            if let data = data, error == nil {
                completion(.success(data.address))
                return
            }
            
            completion(.failure(error ?? .unknown))
        }
    }
}
