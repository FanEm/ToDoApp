//
//  Date+Extensions.swift
//  ToDo
//
//  Created by Artem Novikov on 27.06.2024.
//

import Foundation

extension Date {
    
    static var nextDay: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: .now)!
    }

}
