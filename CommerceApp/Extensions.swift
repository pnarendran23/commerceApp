//
//  Extensions.swift
//  CalendarApp
//
//  Created by Pradheep Narendran P on 29/07/23.
//

import Foundation



extension Int {
    func getAsDoubleDigit() -> String{
        return String(format: "%02d", self)
    }
}

extension Date {
    static func dates(from fromDate: Date, to toDate: Date, calendar: Calendar) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = calendar.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
}

extension String {
    func setAsRupees() -> String{
        return "\u{20B9}" + self
    }
}
