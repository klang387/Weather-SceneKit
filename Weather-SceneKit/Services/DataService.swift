//
//  DataService.swift
//  Weather-SceneKit
//
//  Created by Kevin Langelier on 3/23/19.
//  Copyright © 2019 Kevin Langelier. All rights reserved.
//

import UIKit
import CoreData

class DataService {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let networkService = NetworkService()
    
    func getNewWeather(zipCode: String, completion: @escaping ((Weather?, Error?)->Void)) {
        networkService.getWeatherData(zipCode: zipCode) { [weak self] (data, error) in
            do {
                if let error = error {
                    completion(nil, error)
                }
                guard let data = data else {
                    completion(nil, NetworkError.invalidResponseData)
                    return
                }
                guard let codingUserInfoKeyMOC = CodingUserInfoKey.managedObjectContext else {
                    fatalError("Failed to retrieve context")
                }
                let decoder = JSONDecoder()
                decoder.userInfo[codingUserInfoKeyMOC] = self?.managedObjectContext
                let weather = try decoder.decode(Weather.self, from: data)
                weather.zip = zipCode
                try self?.managedObjectContext.save()
                completion(weather, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    func fetchStoredWeather() -> [Weather] {
        let fetchRequest = NSFetchRequest<Weather>(entityName: "Weather")
        do {
            let weather = try managedObjectContext.fetch(fetchRequest)
            return weather
        } catch {
            print(error)
            return []
        }
    }
    
}
