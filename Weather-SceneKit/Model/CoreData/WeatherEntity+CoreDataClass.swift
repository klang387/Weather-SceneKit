//
//  Weather.swift
//  Weather-SceneKit
//
//  Created by Kevin Langelier on 3/22/19.
//  Copyright © 2019 Kevin Langelier. All rights reserved.
//

import Foundation
import CoreData

class Weather: NSManagedObject, Codable {
    @NSManaged var city: String
    @NSManaged var state: String
    @NSManaged var country: String
    @NSManaged var conditions: String
    @NSManaged var weather: String
    @NSManaged var temperature: Double
    @NSManaged var zip: String?
    
    enum CodingKeys: String, CodingKey {
        case city
        case state
        case country
        case conditions = "current_conditions"
        case weather = "current_weather"
        case temperature
        case zip
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Weather", in: managedObjectContext) else {
                fatalError("Failed to decode Weather")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.city = try container.decode(String.self, forKey: .city)
        self.state = try container.decode(String.self, forKey: .state)
        self.country = try container.decode(String.self, forKey: .country)
        self.conditions = try container.decode(String.self, forKey: .conditions)
        self.weather = try container.decode(String.self, forKey: .weather)
        self.temperature = try container.decode(Double.self, forKey: .temperature)
        self.zip = try container.decodeIfPresent(String.self, forKey: .zip)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(city, forKey: .city)
        try container.encode(state, forKey: .state)
        try container.encode(country, forKey: .country)
        try container.encode(conditions, forKey: .conditions)
        try container.encode(weather, forKey: .weather)
        try container.encode(temperature, forKey: .temperature)
        try container.encode(zip, forKey: .zip)
    }
    
}
