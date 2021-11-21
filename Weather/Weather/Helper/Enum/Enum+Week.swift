//
//  Enum+Week.swift
//  Weather
//
//  Created by Gaurav Malik on 20/11/21.
//

import Foundation

enum Week: Int {
    case Sun = 1
    case Mon
    case Tue
    case Wed
    case Thu
    case Fri
    case Sta
}

extension Week {
    var StringValue: String {
        switch self {
        case .Sun:
            return "Sunday"
        case .Mon:
            return "Monday"
        case .Tue:
            return "Tuesday"
        case .Wed:
            return "Wednesday"
        case .Thu:
            return "Thursday"
        case .Fri:
            return "Friday"
        case .Sta:
            return "Saturday"
        }
    }
}
