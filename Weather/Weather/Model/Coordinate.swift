//
//  Coordinate.swift
//  Weather
//
//  Created by Gaurav Malik on 21/11/21.
//

import Foundation

struct Coordinate: Codable {
    let lat: Double
    let lon: Double
}

extension Coordinate: Equatable {
    static func ==(A: Coordinate, B: Coordinate) -> Bool {
        return A.lat == B.lat && A.lon == B.lon
    }
}
