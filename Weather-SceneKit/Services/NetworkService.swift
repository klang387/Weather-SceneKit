//
//  NetworkService.swift
//  Weather-SceneKit
//
//  Created by Kevin Langelier on 3/22/19.
//  Copyright © 2019 Kevin Langelier. All rights reserved.
//

import Foundation

class NetworkService {
    
    var baseURL = URLComponents(string: "https://sandbox.pandaapi.com/weather/v1/location?zip_code=")
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    func getWeatherData(zipCode: String, completion: @escaping ((Data?, Error?)->Void)) {
        let urlQuery = [URLQueryItem(name: "zip_code", value: zipCode)]
        baseURL?.queryItems = urlQuery
        guard let url = baseURL?.url else {
            completion(nil, NetworkError.invalidURL)
            return
        }
        dataTask?.cancel()
        dataTask = defaultSession.dataTask(with: url, completionHandler: { (data, response, error) in
            completion(data, error)
        })
        dataTask?.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponseData
}
