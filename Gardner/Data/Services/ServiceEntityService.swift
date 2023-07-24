//
//  ServiceEntityService.swift
//  Gardner
//
//  Created by Rashid Khan on 28/05/2023.
//

import Foundation

// MARK: Service Type
protocol ServicesServiceType {
    func getAllServices<T: Decodable>(completion: @escaping CompletionClosure<T>)
    func getService<T: Decodable>(serviceId: String, completion: @escaping CompletionClosure<T>)
    func calculateAmount(addressId: String, serviceId: String, slots: [Slot], completion: @escaping CompletionClosure<CalculateAmountResponse>)
    func getSlots(serviceId: String, serviceType: String, completion: @escaping CompletionClosure<[Slot]>)
}

// MARK: Service Implementation
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

// MARK: Routes
fileprivate enum ServicesAPIRoutes {
    case services
    case service(serviceId: String)
    case calculateAmount(addressId: String, serviceId: String, slots: [Slot])
    case slots(serviceId: String, serviceType: String)
}

extension ServicesAPIRoutes: APIRouteType {
    var path: String {
        switch self {
            case .services: return "v1/service"
            case .service: return "v1/service"
            case .slots: return "v1/slots"
            case .calculateAmount: return "v1/servicerequest/calculate-amount"
        }
    }
    
    var pathVariables: [String]? {
        switch self {
            case .services, .slots, .calculateAmount: return nil
            case .service(serviceId: let serviceId): return [serviceId]
        }
    }
    
    var method: HTTPRequestMethod {
        switch self {
            case .services, .service: return .get
            case .slots, .calculateAmount: return .post
        }
    }
    
    var body: [String : Any]? {
        switch self {
            case .services, .service:
                return nil
            
            case .calculateAmount(let addressId, let serviceId, let slots):
                return ServiceAdd(service: serviceId, address: addressId, slots: slots).dict
            
            case .slots(let serviceId, let serviceType):
                return ["serviceType": serviceType, "serviceId": serviceId]
        }
    }
}
