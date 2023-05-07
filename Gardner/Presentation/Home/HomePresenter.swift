//
//  HomePresenter.swift
//  Gardner
//
//  Created by Rashid Khan on 07/05/2023.
//

import Foundation

protocol HomeServiceType {
}

protocol HomePresenterType {
    func getServices()
}

protocol HomePresenterOutput: AnyObject, LoadingState { }

class HomePresenter: HomePresenterType {
    weak var outputs: HomePresenterOutput?
    private var homeService: HomeServiceType
    
    init(homeService: HomeServiceType) {
        self.homeService = homeService
    }
    
    func getServices() {
        
    }
}
