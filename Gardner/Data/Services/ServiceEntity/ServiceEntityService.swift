//
//  ServiceEntityService.swift
//  Gardner
//
//  Created by Rashid Khan on 28/05/2023.
//

import Foundation

enum PaymentMethod: String, Codable {
    case cash = "cash"
}

struct ServiceRequestParams: Codable {
    let service: String
    let address: String
    let paymentMethod: PaymentMethod
    let slots: [Slot]
}

protocol ServicesServiceType {
    func getAllServices<T: Decodable>(completion: @escaping CompletionClosure<T>)
    func getService<T: Decodable>(serviceId: String, completion: @escaping CompletionClosure<T>)
    func calculateAmount(addressId: String, serviceId: String, slots: [Slot], completion: @escaping CompletionClosure<CalculateAmountResponse>)
    func getSlots(serviceId: String, serviceType: String, completion: @escaping CompletionClosure<[Slot]>)
    func requestService(params: ServiceRequestParams, completion: @escaping CompletionClosure<Bool>)
}

class ServicesService: BaseService, ServicesServiceType {
    func requestService(params: ServiceRequestParams, completion: @escaping CompletionClosure<Bool>) {
        self.request(route: ServicesAPIRoutes.serviceRequest(serviceRequestParams: params)) { (data: EmptyResonseDecodable?, error: NetworkErrors?) in
            if let _ = data, error == nil {
                completion(.success(true))
                return
            }
            
            completion(.failure(error ?? .unknown))
        }
    }
    
    
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
    
    func calculateAmount(addressId: String, serviceId: String, slots: [Slot], completion: @escaping CompletionClosure<CalculateAmountResponse>) {
        let route = ServicesAPIRoutes.calculateAmount(addressId: addressId, serviceId: serviceId, slots: slots)
        
        self.request(route: route) { (data: CalculateAmountResponse?, error: NetworkErrors?) in
            if let data = data, error == nil {
                completion(.success(data))
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
