//
//  WeatherSceneVC.swift
//  Weather-SceneKit
//
//  Created by Kevin Langelier on 3/22/19.
//  Copyright © 2019 Kevin Langelier. All rights reserved.
//

import UIKit
import SceneKit

class WeatherSceneVC: UIViewController {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescLabel: UILabel!
    @IBOutlet weak var sceneView: SCNView!
    
    var weather: Weather!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = weather.city.capitalized + ", " + weather.state.uppercased()

        temperatureLabel.text = String(weather.temperature.rounded(toPlaces: 2)) + "°"
        weatherDescLabel.text = weather.conditions.capitalized
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupScene()
    }
    
    func setupScene() {
        guard let weatherType = WeatherType(rawValue: weather.weather)?.sceneName else { return }
        let scene = SCNScene(named: "SceneAssets.scnassets/\(weatherType).scn")
        sceneView.scene = scene
        let sun = scene?.rootNode.childNode(withName: weatherType, recursively: true)
        sun?.scale = SCNVector3(0.5, 0.5, 0.5)
        
        let rotateAction = SCNAction.rotateBy(x: 0, y: CGFloat(GLKMathDegreesToRadians(360)), z: 0, duration: 10)
        let rotateLoop = SCNAction.repeatForever(rotateAction)
        sun?.runAction(rotateLoop)
    }

}
