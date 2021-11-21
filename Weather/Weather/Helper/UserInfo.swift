//
//  UserInfo.swift
//  Weather
//
//  Created by Gaurav Malik on 21/11/21.
//

import Foundation

struct UserInfo {
    static let cities = "cities"
    static let fahrenheitOrCelsius = "fahrenheitOrCelsius"
    
    static func getCityList() -> [Coordinate]? {
        if let cityLists = UserDefaults.standard.value(forKey: cities) as? Data {
            let cityList = try? PropertyListDecoder().decode([Coordinate].self,
                                                             from: cityLists
            )
            return cityList
        }
        return nil
    }
    
    static func getFahrenheitOrCelsius() -> FahrenheitOrCelsius {
        if let fahrenheitOrCelsius = UserDefaults.standard.string(forKey: fahrenheitOrCelsius),
            let fahrenheitOrCelsiusValue = FahrenheitOrCelsius(rawValue: fahrenheitOrCelsius) {
            return fahrenheitOrCelsiusValue
        }
        return FahrenheitOrCelsius.Celsius
    }
}
