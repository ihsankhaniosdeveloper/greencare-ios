//
//  ServiceEntityService.swift
//  Gardner
//
//  Created by Rashid Khan on 28/05/2023.
//

import Foundation

protocol ServicesServiceType {
    func getAllServices<T: Decodable>(completion: @escaping CompletionClosure<T>)
    func getService<T: Decodable>(serviceId: String, completion: @escaping CompletionClosure<T>)
    func requestService(addressId: String, serviceId: String, slots: [Slot], completion: @escaping CompletionClosure<ServiceRequest>)
    func getSlots(serviceId: String, serviceType: String, completion: @escaping CompletionClosure<[Slot]>)
}

class ServicesService: BaseService, ServicesServiceType {
    
    func getAllServices<T>(completion: @escaping CompletionClosure<T>) where T : Decodable {
        self.request(route: ServicesAPIRoutes.services) { (data: T?, error: NetworkErrors?) in
            if let data = data, error == nil {
                completion(.success(data))
                return
            }
            
            completion(.failure(error ?? .unknown))
        }
    }
    
    func getService<T>(serviceId: String, completion: @escaping CompletionClosure<T>) where T : Decodable {
        self.request(route: ServicesAPIRoutes.service(serviceId: serviceId)) { (data: T?, error: NetworkErrors?) in
            if let data = data, error == nil {
                completion(.success(data))
                return
            }
            
            completion(.failure(error ?? .unknown))
        }
    }
    
    func requestService(addressId: String, serviceId: String, slots: [Slot], completion: @escaping CompletionClosure<ServiceRequest>) {
        let route = ServicesAPIRoutes.requestService(addressId: addressId, serviceId: serviceId, slots: slots)
        
        self.request(route: route) { (data: ServiceRequestReponse?, error: NetworkErrors?) in
            if let data = data, error == nil {
                completion(.success(data.serviceRequest))
                return
            }
            
            completion(.failure(error ?? .unknown))
        }
    }
    
    func getSlots(serviceId: String, serviceType: String, completion: @escaping CompletionClosure<[Slot]>) {
        self.request(route: ServicesAPIRoutes.slots(serviceId: serviceId, serviceType: serviceType)) { (data: SlotsResponse?, error: NetworkErrors?)  in
            if let data = data, error == nil {
                completion(.success(data.slots ?? []))
                return
            }
            
            completion(.failure(error ?? .unknown))
        }
    }
}
