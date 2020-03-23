//
//  CityDetailsViewController.swift
//  BlubDeveloperTest
//
//  Created by Marko Pranjić on 22/03/2020.
//  Copyright © 2020 Marko Pranjić. All rights reserved.
//

import UIKit

class CityDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var CityName: UITextField!
    @IBOutlet weak var Weather: UILabel!
    @IBOutlet weak var Temperature: UILabel!
    @IBOutlet weak var Wind: UILabel!
    
    @IBAction func GetDataFromServer(_ sender: Any) {
        WeatherService.shared.fetchWeather(city: CityName.text!)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
