//
//  AddressService.swift
//  Gardner
//
//  Created by Rashid Khan on 19/05/2023.
//

import Foundation

struct Address: Decodable {
    
}

protocol AddressServiceType {
    func getAddresses(competion: @escaping CompletionClosure<[Address]>)
}

class AddressService: AddressServiceType {
    private var apiClient: APIClientType
    
    init(apiClient: APIClientType) {
        self.apiClient = apiClient
    }
    
    func getAddresses(competion: @escaping CompletionClosure<[Address]>) {
        competion(.success([Address(), Address()]))
    }
}
