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
    // Display a message when the table is empty
    
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
        self.tableView.addSubview(self.refreshControl)
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
            tableView.reloadData()
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
    
    //Row deletion
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {

        self.cities.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        saveCities()
      }
    }
    
    //Refresh control
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                     #selector(MainViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        for c in cities
        {
            fetchWeather(city: c)
        }
        
        cities.sort() { $0.name < $1.name }
        
        self.tableView.reloadData()
        saveCities()
        refreshControl.endRefreshing()
    }
    
    func fetchWeather(city: CityWeather)
        {
            let apiKey = "bf926804600b5db9cca5c7ddbc80165f"
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "api.openweathermap.org"
            urlComponents.path = "/data/2.5/weather"
            urlComponents.queryItems = [
                URLQueryItem(name: "q", value: city.name),
               URLQueryItem(name: "APPID", value: apiKey)
            ]

            guard let validURL = urlComponents.url else {
                print("Failed to create URL...")
                return
            }
            
            URLSession.shared.dataTask(with: validURL) {
                (data, response, error) in
                if let httpResponse = response as? HTTPURLResponse {
                    print("API Status: \(httpResponse.statusCode)")
                    if(httpResponse.statusCode != 200) {
                        return
                    }
                }
                
                guard let validData = data, error == nil else {
                    print("API error: \(error!.localizedDescription)")
                    return
                }
                
                do {
                    let weatherData = try JSONDecoder().decode(WeatherServiceData.self, from: validData)
                    DispatchQueue.main.async {
                        city.name = weatherData.name
                        city.setTemperature(temp: weatherData.main.temp)
                        city.humidity = weatherData.main.humidity
                        city.description = weatherData.weather.description
                    }
                } catch let serializationError {
                    print(serializationError.localizedDescription)
                }
                
            }.resume()
        }
    
}

