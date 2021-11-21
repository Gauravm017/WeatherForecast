//
//  WeatherModel.swift
//  Weather
//
//  Created by Gaurav Malik on 21/11/21.
//

import Foundation


// MARK: WeatherInfo
struct WeatherInfoModel: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int?
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

// MARK: Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: Coord
struct Coord: Codable {
    let lon: Double
    let lat: Double
}

// MARK: Main
struct Main: Codable {
    let temp: Double
    let humidity: Int
    let tempMin: Double
    let tempMax: Double
    let feelsLike: Double?
    let pressure: Double?
    let seaLevel: Double?
    let grndLevel: Double?
    

    enum CodingKeys: String, CodingKey {
        case temp, humidity, pressure
        case grndLevel = "grnd_level"
        case seaLevel = "sea_level"
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

// MARK: Sys
struct Sys: Codable {
    let type: Int?
    let id: Int?
    let country: String
    let sunrise: Int
    let sunset: Int
}

// MARK: Weather
struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// MARK: Wind
struct Wind: Codable {
    let speed: Double
    let deg: Double?
    let gust: Double?
}
