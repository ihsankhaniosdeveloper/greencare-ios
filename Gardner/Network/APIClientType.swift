//
//  NetworkClient.swift
//  Gardner
//
//  Created by Rashid Khan on 18/04/2023.
//

import Foundation
import Alamofire

protocol APIClientType {
    func request(route: APIRouteType, completion: @escaping (APIResponseConvertible) -> Void)
}

class APIClient: APIClientType {
    private var session: Alamofire.Session
    
    public init(session: Alamofire.Session) {
        self.session = session
    }
    
    public func request(route: APIRouteType, completion: @escaping (APIResponseConvertible) -> Void) {
        #if DEBUG
        let urlRequest = route.urlRequest
        var requestUrl = ""
        if let url = urlRequest?.url?.absoluteString {
            requestUrl = url + " -> " + (String(data: urlRequest?.httpBody ?? Data(), encoding: .utf8) ?? "Failed to Convert")
            print("Initiating request: \(requestUrl)")
            print("HEADERS")
            urlRequest?.allHTTPHeaderFields?.forEach { print("\($0.key) : \($0.value)") }
        }
        #endif
        
        self.session.request(route).validate().responseData { response in
            #if DEBUG
            response.data
                .map { String(data: $0, encoding: .utf8)
                    .map { print("Response for : \(requestUrl)" + "\n" + $0) } }
            #endif
            
            if response.error != nil {
                let code = response.response?.statusCode ?? ((response.error!) as NSError).code
                let errorData = response.data ?? Data()
                let apiResponse = APIResponse(code: code, data: errorData)
                completion(apiResponse)
            } else {
                let code = response.response?.statusCode ?? 200
                let data = response.data ?? Data()
                let apiResponse = APIResponse(code: code, data: data)
                completion(apiResponse)
            }
        }
        
    }
    
    private struct APIResponse: APIResponseConvertible {
        let statusCode: Int
        let message: String?
        let data: Data

        init(code: Int, data: Data, message: String? = nil) {
            self.statusCode = code
            self.data = data
            self.message = message
        }
    }
}
