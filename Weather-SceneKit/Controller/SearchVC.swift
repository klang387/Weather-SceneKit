//
//  ViewController.swift
//  Weather-SceneKit
//
//  Created by Kevin Langelier on 3/22/19.
//  Copyright © 2019 Kevin Langelier. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataService = DataService()
    var weatherItems: [Weather] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var zipCodes: Set<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherItems = dataService.fetchStoredWeather()
        zipCodes = Set(weatherItems.compactMap({ $0.zip }))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWeatherSceneVC" {
            let weatherSceneVC = segue.destination as! WeatherSceneVC
            weatherSceneVC.weather = (sender as! Weather)
        }
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}

extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCell.reuseIdentifier, for: indexPath) as! WeatherCell
        cell.cityLabel.text = weatherItems[indexPath.row].city.capitalized
        let temp = weatherItems[indexPath.row].temperature
        cell.temperatureLabel.text = String(temp.rounded(toPlaces: 2))
        let color: UIColor
        if temp > 100 {
            color = #colorLiteral(red: 0.9254902005, green: 0.3997644695, blue: 0.2476535486, alpha: 1)
        } else if temp > 80 {
            color = #colorLiteral(red: 1, green: 0.5607961111, blue: 0.2462077048, alpha: 1)
        } else if temp > 60 {
            color = #colorLiteral(red: 0.9893116443, green: 1, blue: 0.9130815186, alpha: 1)
        } else if temp > 40 {
            color = #colorLiteral(red: 0.7887318699, green: 0.9148805109, blue: 0.9764705896, alpha: 1)
        } else if temp > 20 {
            color = #colorLiteral(red: 0.5853866873, green: 0.8407154079, blue: 1, alpha: 1)
        } else {
            color = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        }
        cell.backgroundColor = color
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsPerRow = 3
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(cellsPerRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(cellsPerRow))
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let weather = weatherItems[indexPath.row]
        performSegue(withIdentifier: "toWeatherSceneVC", sender: weather)
    }
}

extension SearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let zip = searchBar.text, !zip.isEmpty else {
            showAlert("Zip code required!")
            return
        }
        guard let _ = Int(zip), zip.count == 5 else {
            showAlert("Zip code malformed!")
            return
        }
        guard !zipCodes.contains(zip) else {
            showAlert("Zip code already in list!")
            return
        }
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchBar.placeholder = "Searching..."
        dataService.getNewWeather(zipCode: zip) { [weak self] (weather, error) in
            DispatchQueue.main.async {
                searchBar.placeholder = "Zip Code"
                guard let weather = weather else { return }
            
                self?.weatherItems.append(weather)
                self?.zipCodes.insert(zip)
            }
        }
    }
}
