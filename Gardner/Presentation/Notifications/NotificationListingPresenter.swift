//
//  NotificationListingPresenter.swift
//  Gardner
//
//  Created by Rashid Khan on 23/06/2023.
//

import Foundation

protocol NotificationListingPresetnerOutput: AnyObject, LoadingOutputs {
    func notificationsListingPresenter(fetchingSuccess notifications: [Notification])
    func notificationsListingPresenter(fetchingFailed message: String)
}

protocol NotificationListingPresetnerType {
    func getNotification()
}

class NotificationListingPresetner: NotificationListingPresetnerType {
    private var service: NotificationServiceType
    
    weak var outputs: NotificationListingPresetnerOutput?
    
    init(service: NotificationServiceType) {
        self.service = service
    }
    
    
    func getNotification() {
        self.outputs?.startLoading()
        
        self.service.getAll { result in
            self.outputs?.stopLoading()
            
            switch result {
                
            case .success(let notifications):
                self.outputs?.notificationsListingPresenter(fetchingSuccess: notifications)
                
            case .failure(let error):
                self.outputs?.notificationsListingPresenter(fetchingFailed: error.errorDescription ?? error.localizedDescription)
                break
            }
        }
    }
}
