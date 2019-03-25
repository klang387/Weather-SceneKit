//
//  WeatherCell.swift
//  Weather-SceneKit
//
//  Created by Kevin Langelier on 3/22/19.
//  Copyright © 2019 Kevin Langelier. All rights reserved.
//

import UIKit

class WeatherCell: UICollectionViewCell {
    
    static let reuseIdentifier = "WeatherCell"
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
}
