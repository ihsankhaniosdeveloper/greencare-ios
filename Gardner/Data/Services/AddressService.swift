//
//  AddressService.swift
//  Gardner
//
//  Created by Rashid Khan on 19/05/2023.
//

import Foundation

// MARK: - Service Type
protocol AddressServiceType {
    func getAddresses(completion: @escaping CompletionClosure<[Address]>)
    func addAddress(address: AddressAdd, completion: @escaping CompletionClosure<Address>)
    func update(address: Address, completion: @escaping CompletionClosure<EmptyResonseDecodable>)
    func delete(addressId: String, completion: @escaping CompletionClosure<EmptyResonseDecodable>)
}

// MARK: - Service Implementation
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
        self.request(route: AddressRoutes.getAll) { (data: AddressResponse?, error: NetworkErrors?) in
            if let data = data, error == nil {
                completion(.success(data.addresses ?? []))
                return
            }
            
            completion(.failure(error ?? .unknown))
        }
    }
    
    func addAddress(address: AddressAdd, completion: @escaping CompletionClosure<Address>) {
        let route = AddressRoutes.create(address: address)
        
        self.request(route: route) { (data: AddressAddResponse?, error: NetworkErrors?) in
            if let data = data, error == nil {
                completion(.success(data.address))
                return
            }
            
            completion(.failure(error ?? .unknown))
        }
    }
}

// MARK: Routes
fileprivate enum AddressRoutes {
    case getAll
    case create(address: AddressAdd)
    case update(address: Address)
    case delete(addressId: String)
}

extension AddressRoutes: APIRouteType {
    var path: String {
        switch self {
            case .getAll: return "v1/address/get"
            case .create: return "v1/address"
            case .update: return "v1/address/update"
            case .delete: return "v1/address/delete"
        }
    }
    
    var method: HTTPRequestMethod {
        switch self {
            case .getAll: return .get
            case .create, .delete, .update: return .post
        }
    }
    
    var body: [String : Any]? {
        switch self {
            case .getAll: return nil
            case .create(let address): return address.dict
            case .update(let address): return address.dict
            case .delete(let addressId): return ["addressId": addressId]
        }
    }
}
