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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let currentCity = cities[indexPath.row]
        cell.textLabel?.text = currentCity.name
        return cell
    }
    
    @IBAction func unwindToCityList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddCityViewController, let city = sourceViewController.city {
            let newIndexPath = IndexPath(row: cities.count, section: 0)
            
            cities.append(city)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func navigateToAddCity(_ sender: Any) {
    }
    
    
    
}

