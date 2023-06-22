//
//  NotificationListingPresenter.swift
//  Gardner
//
//  Created by Rashid Khan on 23/06/2023.
//

import Foundation

protocol NotificationListingPresetnerOutput: AnyObject, LoadingOutputs {
    
}

protocol NotificationListingPresetnerType {
    
}

class NotificationListingPresetner: NotificationListingPresetnerType {
    private var service: NotificationServiceType
    
    init(service: NotificationServiceType) {
        self.service = service
    }
}
