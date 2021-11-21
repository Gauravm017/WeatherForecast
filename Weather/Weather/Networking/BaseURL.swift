//
//  BaseURL.swift
//  Weather
//
//  Created by Gaurav Malik on 20/11/21.
//

import Foundation

//MARK: BaseURL
struct BaseURL {
    static let weatherURL = "https://api.openweathermap.org"
    static let webURL = "https://weather.com/"
}

//MARK: BasePath
struct BasePath {
    static let list = "/data/2.5/weather"
    static let current = "/data/2.5/forecast"
}
