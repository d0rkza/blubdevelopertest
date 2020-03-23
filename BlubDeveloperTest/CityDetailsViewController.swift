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
    @IBOutlet weak var fetchingDataIndicator: UIActivityIndicatorView!
    
    var weatherInfo: CityWeather?
    
    func fetchWeather(city: String)
        {
            let apiKey = "bf926804600b5db9cca5c7ddbc80165f"
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "api.openweathermap.org"
            urlComponents.path = "/data/2.5/weather"
            urlComponents.queryItems = [
               URLQueryItem(name: "q", value: city),
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
                        let alert = UIAlertController(title: "Something went wrong", message: "We can't find the city you're looking for.", preferredStyle: .alert)

                        self.fetchingDataIndicator.isHidden = true
                        self.fetchingDataIndicator.stopAnimating()
                        
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        
                        return
                    }
                }
                
                guard let validData = data, error == nil else {
                    print("API error: \(error!.localizedDescription)")
                    return
                }
                
                do {
    //                let json = try JSONSerialization.jsonObject(with: validData, options: [])
                    let weatherData = try JSONDecoder().decode(WeatherServiceData.self, from: validData)
                    DispatchQueue.main.async {
                        self.name.text = self.weatherInfo?.name
                        self.currentTemperature.text = "\(String(describing: (Int)(weatherData.main.temp - 273.15)))"
                        self.humidity.text = "\(String(describing: weatherData.main.humidity))"
                        self.weatherDescription.text = weatherData.weather.description.description
                        self.fetchingDataIndicator.stopAnimating()
                    }
                } catch let serializationError {
                    print(serializationError.localizedDescription)
                }
                
            }.resume()
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchingDataIndicator.startAnimating()
        fetchWeather(city: weatherInfo?.name ?? "")
        
        
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
