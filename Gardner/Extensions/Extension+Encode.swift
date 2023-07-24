//
//  Extension+Encode.swift
//  Gardner
//
//  Created by Rashid Khan on 22/07/2023.
//

import Foundation

extension Encodable {
    var dict : [String: Any]? {
        let encoder = JSONEncoder()
        
        encoder.dateEncodingStrategy = .formatted(serverReadableDateTimeFormatter)
        guard let data = try? encoder.encode(self) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return nil }
        return json
    }
    
    private var serverReadableDateTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }
}
