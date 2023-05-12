//
//  BaseService.swift
//  Gardner
//
//  Created by Rashid Khan on 26/04/2023.
//

import Foundation

class BaseService: ServiceType {
    var apiClient: APIClientType
    
    init(apiClient: APIClientType) {
        self.apiClient = apiClient
    }
    
    func request<T>(route: APIRouteType, completion: @escaping (T?, NetworkErrors?) -> Void) where T : Decodable {
        self.apiClient.request(route: route) { apiResponse in
            guard 200...299 ~= apiResponse.statusCode else {
                completion(nil, NetworkErrorHandler.mapError(apiResponse.statusCode, data: apiResponse.data))
                return
            }
            
            do {
                let object: ServerReponse<T> = try self.decode(data: apiResponse.data)
                completion(object.data, nil)
            } catch {
                completion(nil, .parsingError(error))
            }
        }
    }
    
    private func decode<T: Decodable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(serverReadableDateTimeFormatter)
        let result = try decoder.decode(T.self, from: data)
        return result
    }

    private var serverReadableDateTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }
}
