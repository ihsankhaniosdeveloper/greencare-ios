//
//  Date+Formatter.swift
//  Gardner
//
//  Created by Rashid Khan on 21/05/2023.
//

import Foundation

extension Date {
    func toDateString(format: String = "dd-MM-yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func toTimeString(format: String = "h:mm a") -> String {
        let formatter = DateFormatter()
//        formatter.dateStyle = .short
        formatter.dateFormat = format
        
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        return formatter.string(from: self)
    }
}
