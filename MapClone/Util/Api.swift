//
//  Api.swift
//  MapClone
//
//  Created by Tieda Wei on 2019-02-10.
//  Copyright © 2019 Tieda Wei. All rights reserved.
//

import Foundation
import CoreLocation

struct Api {
    let baseURL = "https://api.darksky.net/forecast/"
    let apiKey = ApiKey.weatherApiKey
    let parameters = "?units=auto&exclude=flags,minutely,hourly,daily"
    
    static let shared = Api()
    
    private init() {}
    
    func formatUrlString(by coordinate: CLLocationCoordinate2D) -> String {
        return "\(baseURL)\(apiKey)\(coordinate.latitude),\(coordinate.longitude)\(parameters)"
    }
}
