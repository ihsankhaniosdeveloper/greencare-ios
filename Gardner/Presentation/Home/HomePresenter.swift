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
    func fetchUserProfile()
}

struct SectionItemsData {
    let title: String
    let data: [Service]
}

protocol HomePresenterOutput: AnyObject, LoadingOutputs {
    func homePresenter(homeDataFetchSuccess model: [SectionItemsData])
    func homePresenter(userProfileFetchSuccess profile: UserProfile)
    func homePresenter(homeDataFetchFail message: String)
}

class HomePresenter: HomePresenterType {
    weak var outputs: HomePresenterOutput?
    
    private var homeService: ServicesServiceType
    private var userService: AuthenticationServiceType
    
    init(homeService: ServicesServiceType, userService: AuthenticationServiceType) {
        self.homeService = homeService
        self.userService = userService
    }
    
    func getServices() {
        self.outputs?.startLoading()
        
        homeService.getAllServices { (result: Result<HomeDataResponse, NetworkErrors>) in
            self.outputs?.stopLoading()
            
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
    
    func fetchUserProfile() {
        if let userProfile = UserSession.instance.profile {
            self.outputs?.homePresenter(userProfileFetchSuccess: userProfile)
            return
        }
        
        self.userService.getUser { result in
            switch result {
                
            case .success(let profile):
                UserSession.instance.profile = profile
                self.outputs?.homePresenter(userProfileFetchSuccess: profile)
                
            case .failure(let error):
                self.outputs?.homePresenter(homeDataFetchFail: error.errorDescription ?? error.localizedDescription)
            }
        }
    }
}
