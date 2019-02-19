//
//  Config.swift
//  MapClone
//
//  Created by Tieda Wei on 2019-02-18.
//  Copyright © 2019 Tieda Wei. All rights reserved.
//

import Foundation

struct API {
    static let key = Key.weatherApiKey.rawValue
    static let baseURL = URL(string: "https://api.darksky.net/forecast/")!
    static let authenticatedURL = baseURL.appendingPathComponent(key)
}
