//
//  DateExtensions.swift
//  Goal
//
//  Created by Tung Nguyen on 03/01/2024.
//

import Foundation

enum DateTimeFormat: String {
    case yyyyMMddHHmmssZ = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    case hhmm = "HH:mm"
    case ddMM = "dd/MM"
}

extension String {
    
    func toDate(format: DateTimeFormat) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.date(from: self)
    }
    
}

extension Date {
    
    func toString(format: DateTimeFormat) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
    
}
