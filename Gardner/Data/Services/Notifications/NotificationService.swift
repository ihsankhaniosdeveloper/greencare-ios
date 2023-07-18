//
//  NotificationService.swift
//  Gardner
//
//  Created by Rashid Khan on 23/06/2023.
//

import Foundation

// MARK: -- Notifications Service
protocol NotificationServiceType {
    func getAll(completion: @escaping CompletionClosure<[Notification]>)
}

class NotificationService: BaseService, NotificationServiceType {
    func getAll(completion: @escaping CompletionClosure<[Notification]>) {
        self.request(route: NotificationRoutes.getAll) { (data: NotificationResponse?, error: NetworkErrors?) in
            if let data = data, error == nil {
                completion(.success(data.notifications))
                return
            }
            
            completion(.failure(error ?? .unknown))
        }
    }
}

// MARK: -- Notifications Routes
enum NotificationRoutes {
    case getAll
}

extension NotificationRoutes: APIRouteType {
    var path: String {
        switch self {
            case .getAll: return "v1/notifications"
        }
    }
    
    var method: HTTPRequestMethod {
        switch self {
            case .getAll: return .get
        }
    }
    
    
}
