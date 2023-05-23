//
//  HomePresenter.swift
//  Gardner
//
//  Created by Rashid Khan on 07/05/2023.
//

import Foundation

struct ServiceRequestReponse: Codable {
    let serviceRequest: ServiceRequest
}

struct ServiceRequest: Codable {
    let id: String?
    let service: Service?
    let status: String?
    let promo: [String]?
    let address: Address?
    let user: String?
    let discount, totalPrice, discountAmount: Int?
    let isDeleted: Bool?
    let createdAt, updatedAt: Date?
    let v: Int?
    let slot: ServiceRequestSlot?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case service, status, promo, address, user, discount, totalPrice, discountAmount, isDeleted, createdAt, updatedAt
        case v = "__v"
        case slot
    }
}

struct ServiceRequestSlot: Codable {
    let serviceRequest: String?
    let slots: [SlotElement]?
    let isReserved: Bool?
    let id: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case serviceRequest, slots, isReserved
        case id = "_id"
        case v = "__v"
    }
}

struct SlotElement: Codable {
    let date: String?
    let timeSlots: [Date]?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case date, timeSlots
        case id = "_id"
    }
}

enum ServicesAPIRoutes {
    case services
    case service(serviceId: String)
    case requestService(addressId: String, serviceId: String, slots: [Slot])
}

extension ServicesAPIRoutes: APIRouteType {
    var path: String {
        switch self {
            case .services: return "v1/service"
            case .service: return "v1/service"
            case .requestService: return "v1/servicerequest"
        }
    }
    
    var pathVariables: [String]? {
        switch self {
            case .services: return nil
            case .service(serviceId: let serviceId): return [serviceId]
            case .requestService: return nil
        }
    }
    
    var method: HTTPRequestMethod {
        switch self {
            case .services, .service: return .get
            case .requestService: return .post
        }
    }
    
    var body: [String : Any]? {
        switch self {
            case .services, .service: return nil
            case .requestService(let addressId, let serviceId, let slots):
                return ServiceAdd(service: serviceId, address: addressId, slots: slots).dict
        }
    }
}

struct HomeDataResponse: Decodable {
    let recurringServices: [Service]?
    let oneTimeServices: [Service]?
    let contactOnlyServices: [Service]?
    let sliders: [String]?
}

protocol ServicesServiceType {
    func getAllServices<T: Decodable>(completion: @escaping CompletionClosure<T>)
    func getService<T: Decodable>(serviceId: String, completion: @escaping CompletionClosure<T>)
    func requestService(addressId: String, serviceId: String, slots: [Slot], completion: @escaping CompletionClosure<ServiceRequest>)
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
}

protocol HomePresenterType {
    func getServices()
}

struct SectionItemsData {
    let title: String
    let data: [Service]
}

protocol HomePresenterOutput: AnyObject, LoadingState {
    func homePresenter(homeDataFetchSuccess model: [SectionItemsData])
    func homePresenter(homeDataFetchFail message: String)
}

class HomePresenter: HomePresenterType {
    weak var outputs: HomePresenterOutput?
    private var homeService: ServicesServiceType
    
    init(homeService: ServicesServiceType) {
        self.homeService = homeService
    }
    
    func getServices() {
        self.outputs?.showLoader()
        
        homeService.getAllServices { (result: Result<HomeDataResponse, NetworkErrors>) in
            self.outputs?.showLoader()
            
            switch result {
                
            case .success(let homeDataResponse):
                var result: [SectionItemsData] = []
                
                if let recuringServices = homeDataResponse.recurringServices {
                    result.append(SectionItemsData(title: "Recuring Services", data: recuringServices))
                }
                
                if let oneTimeServices = homeDataResponse.oneTimeServices {
                    result.append(SectionItemsData(title: "One Time Services", data: oneTimeServices))
                }
                
                if let contactOnlyServices = homeDataResponse.contactOnlyServices {
                    result.append(SectionItemsData(title: "Contact Only Services", data: contactOnlyServices))
                }
                
                
                self.outputs?.homePresenter(homeDataFetchSuccess: result)
                break
                
            case .failure(let error):
                self.outputs?.homePresenter(homeDataFetchFail: error.localizedDescription)
                break
            }
        }
    }
}
