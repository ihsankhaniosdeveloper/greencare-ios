//
//  ScheduleAddPresenter.swift
//  Gardner
//
//  Created by Rashid Khan on 12/05/2023.
//

import Foundation

protocol ScheduleAddPresenterOutput: AnyObject {
    
}

protocol ScheduleAddPresenterType: AnyObject {
    
}

class ScheduleAddPresenter: ScheduleAddPresenterType {
    weak var outputs: ScheduleAddPresenterOutput?
}
