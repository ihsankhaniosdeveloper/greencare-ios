//
//  SlotService.swift
//  Gardner
//
//  Created by Rashid Khan on 20/05/2023.
//

import Foundation

struct SlotsResponse: Codable {
    let slots: [Slot]?
    let type: String?
    let reservedSlots: [Slot]?
    let startDate: Date?
    let endDate: Date?
}

struct Slot: Codable {
    let date: Date
    let timeSlots: [Date]
}

protocol SlotServiceType {
    func getSlots(serviceType: String, completion: @escaping CompletionClosure<[Slot]>)
}

class SlotService: BaseService, SlotServiceType {
    func getSlots(serviceType: String, completion: @escaping CompletionClosure<[Slot]>) {
        self.request(route: SlotRoutes.getSlots(serviceId: serviceType)) { (data: SlotsResponse?, error: NetworkErrors?)  in
            if let data = data, error == nil {
                completion(.success(data.slots ?? []))
                return
            }
            
            completion(.failure(error ?? .unknown))
        }
    }
    
    
}

enum SlotRoutes {
    case getSlots(serviceId: String)
}

extension SlotRoutes: APIRouteType {
    var path: String {
        switch self {
            case .getSlots: return "v1/slots"
        }
    }
    
    var method: HTTPRequestMethod {
        switch self {
            case .getSlots: return .post
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .getSlots(let serviceId):
            return ["serviceType": serviceId]
        }
    }
}
