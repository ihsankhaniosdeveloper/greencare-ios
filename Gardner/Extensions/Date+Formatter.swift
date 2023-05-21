//
//  Date+Formatter.swift
//  Gardner
//
//  Created by Rashid Khan on 21/05/2023.
//

import Foundation

extension Date {
    func toDateString(format: String = "dd mmm yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func toTimeString(format: String = "h:mm a") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        return formatter.string(from: self)
    }
    
    func toStringServerFormate() -> String {
        return serverReadableDateTimeFormatter.string(from: self)
    }
    
    private var serverReadableDateTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }
}
