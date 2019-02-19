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
    let currently: CurrentWeather
    
    struct CurrentWeather: Codable {
        let time: Date
        let summary: String
        let icon: String
        let temperature: Double
        let humidity: Double
    }
}
