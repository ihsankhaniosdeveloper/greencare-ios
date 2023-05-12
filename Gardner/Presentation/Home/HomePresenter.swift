//
//  HomePresenter.swift
//  Gardner
//
//  Created by Rashid Khan on 07/05/2023.
//

import Foundation

enum ServicesAPIRoutes {
    case services
    case service
}

extension ServicesAPIRoutes: APIRouteType {
    var url: URL {
        return URL(string: "http://18.212.71.66:4000/api/v1/")!
    }
    
    var path: String {
        switch self {
            case .services: return "service"
            case .service: return ""
        }
    }
    
    var method: HTTPRequestMethod {
        return .get
    }
    
    var headers: [String : String] {
        return ["Authorization": UserSession.instance.token]
    }
}

struct HomeDataResponse: Decodable {
    let recurringServices: [Service]?
    let oneTimeServices: [Service]?
    let sliders: [String]?
}

protocol HomeServiceType {
    func getHomeData<T: Decodable>(completion: @escaping CompletionClosure<T>)
}

class HomeService: BaseService, HomeServiceType {
    
    
    func getHomeData<T>(completion: @escaping CompletionClosure<T>) where T : Decodable {
        self.request(route: ServicesAPIRoutes.services) { (data: T?, error: NetworkErrors?) in
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

protocol HomePresenterOutput: AnyObject, LoadingState {
    func homePresenter(homeDataFetchSuccess model: [[Service]])
    func homePresenter(homeDataFetchFail message: String)
}

class HomePresenter: HomePresenterType {
    weak var outputs: HomePresenterOutput?
    private var homeService: HomeServiceType
    
    init(homeService: HomeServiceType) {
        self.homeService = homeService
    }
    
    func getServices() {
        self.outputs?.showLoader()
        
        let res = [[Service(id: nil, title: nil, description: nil, plants: nil, hours: nil, persons: nil, subType: nil, instructions: nil, type: nil, price: nil, promo: nil, isDeleted: nil, isActive: nil, image: nil, backgroundImage: nil, contactLink: nil, isContactOnly: nil, createdAt: nil, updatedAt: nil, v: nil)]]
        self.outputs?.homePresenter(homeDataFetchSuccess: res)
        
        homeService.getHomeData { (result: Result<HomeDataResponse, NetworkErrors>) in
            self.outputs?.showLoader()
            
            switch result {
                
            case .success(let homeDataResponse):
                var result: [[Service]] = []
                
                if let recuringServices = homeDataResponse.recurringServices {
                    result.append(recuringServices)
                }
                
                if let oneTimeServices = homeDataResponse.oneTimeServices {
                    result.append(oneTimeServices)
                }
                
                break
                
            case .failure(let error):
                self.outputs?.homePresenter(homeDataFetchFail: error.localizedDescription)
                break
            }
        }
    }
}
