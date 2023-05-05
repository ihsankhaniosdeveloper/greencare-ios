//
//  APIResponseConvertible.swift
//  Gardner
//
//  Created by Rashid Khan on 18/04/2023.
//

import Foundation

protocol APIResponseConvertible: Codable {
    var statusCode: Int { get }
    var data: Data { get }
    var message: String? { get }
}
