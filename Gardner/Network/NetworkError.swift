//
//  NetworkError.swift
//  Gardner
//
//  Created by Rashid Khan on 22/04/2023.
//

import Foundation

enum NetworkErrors: LocalizedError {
    case noInternet
    case requestTimedOut
    case badGateway
    case notFound
    case forbidden
    case internalServerError(InternalServerError?)
    case serverError(Int, String)
    case authError(AuthError?)
    case existingEmiratesID
    case unknown

    struct InternalServerError: Codable {
        let errors: [ServerError]
        
        struct ServerError: Codable {
            public let code: String
            public let message: String
        }
    }

    struct AuthError: Codable {
        let error: AuthErrorDetail
        
        struct AuthErrorDetail: Codable {
            public let code: String
            public let message: String
        }
    }
}

extension NetworkErrors {
    public var errorDescription: String? {
        switch self {
        case .noInternet: return "Looks like you're offline. Please reconnect and refresh to continue using App."
        case .requestTimedOut: return "The request is timeout!"
        case .badGateway: return "Bad Gateway"
        case .notFound: return "Resource Not Found"
        case .forbidden: return "You don't have access to this information"
        case .internalServerError(let serverErrors):
            if let error = serverErrors?.errors.first { return error.message }
            else { return "Sorry, that doesn't look right." }
        case .serverError(_, let message): return message
        case .authError(let authError):
            if let authError = authError { return authError.error.message }
            else { return "Sorry, that doesn't look right." }
        default: return "Looks like you're offline. Please reconnect and refresh to continue using App."
        }
    }
}

class NetworkErrorHandler {

    static func decode<T: Codable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }

    static func mapError(_ code: Int, data: Data) -> NetworkErrors {
        switch code {
        case 401:
            let authError: NetworkErrors.AuthError? = try? decode(data: data)
            return .authError(authError)
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 400...499:
            let serverErrors: NetworkErrors.InternalServerError? = try? decode(data: data)
            return .internalServerError(serverErrors)
        case 502:
            return .badGateway
        case -1009:
            return .noInternet
        case -1001:
            return .requestTimedOut
        case 1041:
            return .existingEmiratesID
        default:
            return .unknown
        }
    }
}
