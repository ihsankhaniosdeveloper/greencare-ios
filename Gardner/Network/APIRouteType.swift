//
//  AppURLRequestConvertible.swift
//  Gardner
//
//  Created by Rashid Khan on 18/04/2023.
//

import Foundation

import Alamofire

typealias HTTPRequestMethod = HTTPMethod

enum RequestType: Int, Hashable {
    case json
    case multiPart
}

protocol APIRouteType: URLRequestConvertible {
    var url: URL { get }
    var path: String { get }
    var method: HTTPRequestMethod { get }
    var requestType: RequestType { get }
    var pathVariables: [String]? { get }
    var query: [String: String]? { get }
    var headers: [String: String] { get }
    var body: [String: Any]? { get }
}

extension APIRouteType {
    func asURLRequest() throws -> URLRequest {
        let url = try constructAPIUrl()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = self.method.rawValue
        
        var requestTypeHeaders: [String: String] {
            switch requestType {
                case .json: return ["Content-Type": "application/json", "Accept": "application/json"]
                case .multiPart: return ["": ""]
            }
        }
        
        for (key, value) in requestTypeHeaders {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        for (key, value) in headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: self.body ?? [:])

        return urlRequest
        
    }
    
    private func constructAPIUrl() throws -> URL {

        var constructedURL = url.appendingPathComponent(path)

        if let pathVariables = pathVariables {
            for pathVariable in pathVariables {
                constructedURL.appendPathComponent(pathVariable)
            }
        }

        if let query = query {
            var components = URLComponents(string: constructedURL.absoluteString)!
            var queryItems = [URLQueryItem]()
            for (key, value) in query {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
            components.queryItems = queryItems
            return components.url!
        }

        return constructedURL
    }
}

extension APIRouteType {
    var requestType: RequestType {
        return .json
    }
    
    var pathVariables: [String]? {
        return nil
    }
    
    var query: [String: String]? {
        return nil
    }
    
    var body: [String: Any]? {
        return nil
    }
    
    var headers: [String : String] {
        return [:]
    }
}
