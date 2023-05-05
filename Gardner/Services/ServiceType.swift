//
//  ServiceType.swift
//  Gardner
//
//  Created by Rashid Khan on 26/04/2023.
//

import Foundation

protocol ServiceType: AnyObject {
    var apiClient: APIClientType { get }
    
    func request<T: Decodable>(route: APIRouteType, completion: @escaping (T?, NetworkErrors?)->Void)
}
