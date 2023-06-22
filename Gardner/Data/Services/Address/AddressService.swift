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
    let addressId:String?

    var completeAddress: String {
        var address = ""
        
        if let buildingName = self.buildingName {
            address += "\(buildingName), "
        }
        
        if let streetName = self.streetName {
            address += "\(streetName), "
        }
        
        if let area = self.area {
            address += "\(area), "
        }
        
        if let city = self.city {
            address += "\(city)"
        }
        
        return address
    }

    enum CodingKeys: String, CodingKey {
        case title, area, streetName, buildingName, city, instructions
        case id = "_id"
        case createdAt
        case v = "__v"
        case addressId
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.addressId, forKey: .addressId)
        try container.encodeIfPresent(self.title, forKey: .title)
        try container.encodeIfPresent(self.area, forKey: .area)
        try container.encodeIfPresent(self.streetName, forKey: .streetName)
        try container.encodeIfPresent(self.buildingName, forKey: .buildingName)
        try container.encodeIfPresent(self.city, forKey: .city)
        try container.encodeIfPresent(self.instructions, forKey: .instructions)
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
    func update(address: Address, completion: @escaping CompletionClosure<EmptyResonseDecodable>)
    func delete(addressId: String, completion: @escaping CompletionClosure<EmptyResonseDecodable>)
}

class AddressService: BaseService, AddressServiceType {
    func update(address: Address, completion: @escaping CompletionClosure<EmptyResonseDecodable>) {
        self.request(route: AddressRoutes.update(address: address)) { (data: EmptyResonseDecodable?, error: NetworkErrors?) in
            if let data = data, error == nil {
                completion(.success(data))
                return
            }
            
            completion(.failure(error ?? .unknown))
        }
    }
    
    func delete(addressId: String, completion: @escaping CompletionClosure<EmptyResonseDecodable>) {
        self.request(route: AddressRoutes.delete(addressId: addressId)) { (data: EmptyResonseDecodable?, error: NetworkErrors?) in
            if let data = data, error == nil {
                completion(.success(data))
                return
            }
            
            completion(.failure(error ?? .unknown))
        }
    }
    
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
