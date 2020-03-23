//
//  ViewController.swift
//  BlubDeveloperTest
//
//  Created by Marko Pranjić on 22/03/2020.
//  Copyright © 2020 Marko Pranjić. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var cities = [CityWeather]()
    
    func saveCities() {
        
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode Note
            let data = try encoder.encode(cities)

            // Write/Set Data
            UserDefaults.standard.set(data, forKey: "savedCities")

        } catch {
            print("Unable to Encode Array of Notes (\(error))")
        }
    }
    
    func loadCities() {
        if let data = UserDefaults.standard.data(forKey: "savedCities") {
        do {
            // Create JSON Decoder
            let decoder = JSONDecoder()

            // Decode city
            cities = try decoder.decode([CityWeather].self, from: data)

        } catch {
            print("Unable to Decode Note (\(error))")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCities()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "WeatherTableCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WeatherTableCell  else {
            fatalError("The dequeued cell is not an instance of WeatherTableCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let city = cities[indexPath.row]
        
        cell.cityName.text = city.name
        cell.cityTemperature.text = "\(city.temperature ?? -300) °C"
   
        return cell
    }
    
    //Accepts parameters from segue and add them to the table view
    @IBAction func unwindToCityList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddCityViewController, let city = sourceViewController.city {
            let newIndexPath = IndexPath(row: cities.count, section: 0)
            
            cities.append(city)
            saveCities()
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
            
        case "AddCitySegue":
            print("Adding new city")
            
        case "CityDetailsSegue":
            guard let cityDetailsViewController = segue.destination as? CityDetailsViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedCityCell = sender as? WeatherTableCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            guard let indexPath = tableView.indexPath(for: selectedCityCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedCity = cities[indexPath.row]
            cityDetailsViewController.weatherInfo = selectedCity
        default:
            print("This shouldn't be here")
        }
    }
    
}

