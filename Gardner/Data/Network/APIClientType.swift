//
//  NetworkClient.swift
//  Gardner
//
//  Created by Rashid Khan on 18/04/2023.
//

import Foundation
import Alamofire

protocol DocumentDataConvertible: Codable {
    var data: Data { get }
    var name: String { get }
    var fileName: String { get }
    var mimeType: String { get }
}

protocol APIClientType {
    func request(route: APIRouteType, completion: @escaping (APIResponseConvertible) -> Void)
    func upload(documents: [DocumentDataConvertible],
                route: APIRouteType,
                otherFormValues formValues: [String: String],
                prgoress: @escaping (Progress) -> Void,
                completion: @escaping (APIResponseConvertible) -> Void
    )
}

class APIClient: APIClientType {
    func upload(documents: [DocumentDataConvertible], route: APIRouteType, otherFormValues formValues: [String : String], prgoress: @escaping (Progress) -> Void, completion: @escaping (APIResponseConvertible) -> Void) {
        #if DEBUG
            let urlRequest = route.urlRequest
            if let url = urlRequest?.url?.absoluteString {
                print(url + " -> " + (String(data: urlRequest?.httpBody ?? Data(), encoding: .utf8) ?? "Failed to Convert"))
            }
        #endif
    
        self.session.upload(multipartFormData: { multipartFormData in
            documents.forEach { multipartFormData.append($0.data, withName: $0.name, fileName: $0.fileName, mimeType: $0.mimeType) }
            formValues.forEach { multipartFormData.append($0.value.data(using: .utf8) ?? Data(), withName: $0.key) }
            
        }, with: try! route.asURLRequest()).response { response in
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
        let data: Data

        init(code: Int, data: Data) {
            self.statusCode = code
            self.data = data
        }
    }
}

struct ServerReponse<T: Decodable>: Decodable {
    let statusCode: Int
    let message: String?
    let data: T
}
