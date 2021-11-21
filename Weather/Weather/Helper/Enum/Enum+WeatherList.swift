//
//  Enum+WeatherList.swift
//  Weather
//
//  Created by Gaurav Malik on 20/11/21.
//

import UIKit

enum WeatherListCellType: Int {
    case City = 0
    case Setting
}

extension WeatherListCellType: CaseIterable {}
