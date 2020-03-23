//
//  CityDetailsViewController.swift
//  BlubDeveloperTest
//
//  Created by Marko Pranjić on 22/03/2020.
//  Copyright © 2020 Marko Pranjić. All rights reserved.
//

import UIKit

class CityDetailsViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    
    var weatherInfo: CityWeather?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        weatherInfo = WeatherService.shared.fetchWeather(city: weatherInfo?.name ?? "")
        if(weatherInfo != nil) {
            name.text = weatherInfo?.name
            currentTemperature.text = "\(String(describing: weatherInfo?.temperature))"
            humidity.text = "\(String(describing: weatherInfo?.humidity))"
            weatherDescription.text = weatherDescription?.description
        }
        
        
        // Do any additional setup after loading the view.
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
