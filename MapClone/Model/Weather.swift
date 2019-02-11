//
//  Temperature.swift
//  MapClone
//
//  Created by Tieda Wei on 2019-02-10.
//  Copyright © 2019 Tieda Wei. All rights reserved.
//

import Foundation

struct Weather: Decodable {
    let latitude, longitude: Double
    let timezone: String
    let currently: Currently
    let offset: Int
}

struct Currently: Decodable {
    let time: Int
    let summary, icon: String
    let nearestStormDistance, nearestStormBearing, precipIntensity, precipProbability: Int
    let temperature, apparentTemperature, dewPoint, humidity: Double
    let pressure, windSpeed, windGust: Double
    let windBearing: Int
    let cloudCover: Double
    let uvIndex: Int
    let visibility: Double
    let ozone: Double
}
