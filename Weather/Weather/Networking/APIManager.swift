//
//  APIManager.swift
//  Weather
//
//  Created by Gaurav Malik on 21/11/21.
//

import Foundation

typealias WeatherModelCallback = (_ model: WeatherInfoModel?) -> Void
typealias DayWeatherForecastModelCallback = (_ model: FiveDayWeather?) -> Void

final class APIManager{
    class func getWeatherByCoordinate(latitude lat: Double, longitude lon: Double, handler: @escaping WeatherModelCallback) {
        let parameters: [String: Any] = [
            "lat" : "\(lat)",
            "lon" : "\(lon)",
            "appid" : weatherAPIKey
        ]
        
        let request = APIRequest(method: .get,
                                 path: BasePath.list,
                                 queryItems: parameters
        )
        APICenter().performSync(urlString: BaseURL.weatherURL,
                            request: request
        ) {(result) in
            switch result {
            case .success(let response):
                if let response = try? response.decode(to: WeatherInfoModel.self) {
                    handler(response.body)
                } else {
                    print(APIError.decodingFailed)
                }
            case .failure:
                print(APIError.networkFailed)
            }
        }
    }
    
    class func get5DayWeatherByCoordinate(latitude lat: Double, longitude lon: Double, handler: @escaping DayWeatherForecastModelCallback) {
        let parameters: [String: Any] = [
            "lat" : "\(lat)",
            "lon" : "\(lon)",
            "appid" : weatherAPIKey
        ]
                
        let request = APIRequest(method: .get,
                                 path: BasePath.current,
                                 queryItems: parameters
        )
        
        APICenter().perform(urlString: BaseURL.weatherURL,
                            request: request
        ) {(result) in
            switch result {
            case .success(let response):
                if let response = try? response.decode(to: FiveDayWeather.self) {
                    handler(response.body)
                } else {
                    print(APIError.decodingFailed)
                }
            case .failure:
                print(APIError.networkFailed)
            }
        }
    }
}
