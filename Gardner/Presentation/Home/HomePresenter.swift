//
//  HomePresenter.swift
//  Gardner
//
//  Created by Rashid Khan on 07/05/2023.
//

import Foundation

struct HomeDataResponse: Decodable {
    let recurringServices: [Service]?
    let oneTimeServices: [Service]?
    let contactOnlyServices: [Service]?
    let sliders: [String]?
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
