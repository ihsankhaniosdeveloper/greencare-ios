//
//  HomePresenter.swift
//  Gardner
//
//  Created by Rashid Khan on 07/05/2023.
//

import Foundation

enum ServicesAPIRoutes {
    case services
    case service(serviceId: String)
}

extension ServicesAPIRoutes: APIRouteType {
    var url: URL {
        return URL(string: "http://3.84.7.206:4000/api/v1/")!
    }
    
    var path: String {
        switch self {
            case .services: return "service"
            case .service: return "service"
        }
    }
    
    var pathVariables: [String]? {
        switch self {
            case .services: return nil
            case .service(serviceId: let serviceId): return [serviceId]
        }
    }
    
    var method: HTTPRequestMethod {
        return .get
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
