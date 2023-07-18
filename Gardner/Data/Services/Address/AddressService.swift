//
//  AddressService.swift
//  Gardner
//
//  Created by Rashid Khan on 19/05/2023.
//

import Foundation

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
