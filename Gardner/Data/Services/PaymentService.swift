//
//  PaymentService.swift
//  Gardner
//
//  Created by Rashid Khan on 20/07/2023.
//

import Foundation

// MARK: Payment Service
protocol PaymentServiceType {
    func createPaymentIntent(amount: Double, completion: @escaping CompletionClosure<PaymentIntent>)
}

class paymentService: BaseService, PaymentServiceType {
    func createPaymentIntent(amount: Double, completion: @escaping CompletionClosure<PaymentIntent>) {
        
        self.request(route: PaymentRoutes.paymentIntent(amount: amount)) { (data: PaymentIntentResponse?, error: NetworkErrors?) in
            if let data = data, error == nil {
                completion(.success(data.paymentIntent))
                return
            }
            
            completion(.failure(error ?? .unknown))
        }
    }
}


// MARK: -- Payment Routes
enum PaymentRoutes {
    case paymentIntent(amount: Double)
}

extension PaymentRoutes: APIRouteType {
    var path: String {
        switch self {
            case .paymentIntent: return "v1/payment/payment_intent"
        }
    }
    
    var method: HTTPRequestMethod {
        switch self {
            case .paymentIntent: return .post
        }
    }
    
    var body: [String : Any]? {
        switch self {
            case .paymentIntent(let amount): return ["amount": amount]
        }
    }
}
