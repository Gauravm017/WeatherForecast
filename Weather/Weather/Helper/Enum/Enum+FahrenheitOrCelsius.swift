//
//  Enum+FahrenheitOrCelsius.swift
//  Weather
//
//  Created by Gaurav Malik on 20/11/21.
//

import Foundation

enum FahrenheitOrCelsius: String {
    case Fahrenheit
    case Celsius
}

extension FahrenheitOrCelsius {
    var stringValue: String {
        return "\(self)"
    }
    
    var emoji: String {
        switch self {
        case .Celsius:
            return "℃"
        case .Fahrenheit:
            return "℉"
        }
    }
}
