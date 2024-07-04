//
//  Date+Extensions.swift
//  ToDo
//
//  Created by Artem Novikov on 27.06.2024.
//

import Foundation

extension Date {

    static var nextDay: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: .now)!.stripTime()
    }

    var dayAndMonthString: String {
        formatted(.dateTime.day(.twoDigits).month(.abbreviated))
    }

    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }

}
