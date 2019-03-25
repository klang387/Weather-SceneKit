//
//  SceneNames.swift
//  Weather-SceneKit
//
//  Created by Kevin Langelier on 3/22/19.
//  Copyright © 2019 Kevin Langelier. All rights reserved.
//

import Foundation

enum WeatherType: String {
    case clearDay = "clear day"
    case clearNight = "clear night"
    case rain
    case snow
    case sleet
    case wind
    case fog
    case cloudy
    case partlyCloudDay = "partly cloudy-day"
    case partlyCloudyNight = "partly cloudy-night"
    
    var sceneName: String {
        var name: String
        switch self {
        case .clearDay:
            name = "sun"
        case .clearNight:
            name = "moon"
        case .rain, .sleet:
            name = "lightning_bolt"
        case .snow:
            name = "snow"
        case .cloudy, .partlyCloudDay, .partlyCloudyNight, .wind, .fog:
            name = "cloud"
        }
        return name
    }
}
