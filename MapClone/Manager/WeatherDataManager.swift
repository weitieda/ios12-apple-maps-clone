//
//  WeatherDataManager.swift
//  MapClone
//
//  Created by Tieda Wei on 2019-02-18.
//  Copyright © 2019 Tieda Wei. All rights reserved.
//

import Foundation

enum DataManagerError: Error {
    case failedRequest
    case invalidResponse
    case unknown
}


final class WeatherDataManager {
    private let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    static let shared = WeatherDataManager(baseURL: API.authenticatedURL)
    
    func getWeatherDataAt(latitude: Double, longitude: Double, completion: @escaping (Weather?, DataManagerError?) -> Void) {
        let url = baseURL.appendingPathComponent("\(latitude), \(longitude)")
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            self.didFinishGettingWeatherData(data: data, response: response, error: err, completion: completion)
        }.resume()
    }
    
    func didFinishGettingWeatherData(data: Data?, response: URLResponse?, error: Error?, completion: (Weather?, DataManagerError?) -> Void) {
        if let _ = error {
            completion(nil, .failedRequest)
        } else if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    let weatherData = try decoder.decode(Weather.self, from: data)
                    completion(weatherData, nil)
                } catch {
                    completion(nil, DataManagerError.invalidResponse)
                }
            } else {
                completion(nil, .failedRequest)
            }
        } else {
            completion(nil, .unknown)
        }
    }
}
