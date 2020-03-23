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
    var cities = [
    City(name: "Velenje"),
    City(name: "Ljubljana"),
    City(name: "London")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    @IBAction func navigateToAddCity(_ sender: Any) {
    }
    
    
    
}

