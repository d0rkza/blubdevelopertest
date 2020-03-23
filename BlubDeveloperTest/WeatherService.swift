//
//  WeatherService.swift
//  BlubDeveloperTest
//
//  Created by Marko Pranjić on 22/03/2020.
//  Copyright © 2020 Marko Pranjić. All rights reserved.
//

import Foundation

struct WeatherService
{
    //example: api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=bf926804600b5db9cca5c7ddbc80165f
    private init() {}
    static let shared = WeatherService()

    var urlComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.openweathermap.org"
        return urlComponents
    }
    
    let apiKey = "bf926804600b5db9cca5c7ddbc80165f"
    
    func fetchWeather(city: String) -> CityWeather?
    {
        if(city == "") { return nil }
        var cityWeather = CityWeather()
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
            return nil
        }
        
        URLSession.shared.dataTask(with: validURL) {
            (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                print("API Status: \(httpResponse.statusCode)")
            }
            
            guard let validData = data, error == nil else {
                print("API error: \(error!.localizedDescription)")
                return
            }
            
            do {
//                let json = try JSONSerialization.jsonObject(with: validData, options: [])
                let weatherData = try JSONDecoder().decode(WeatherServiceData.self, from: validData)
//                print(weatherData)
                cityWeather.name = weatherData.name
                cityWeather.temperature = weatherData.main.temp
                cityWeather.humidity = weatherData.main.humidity
                cityWeather.description = weatherData.weather.description
                
            } catch let serializationError {
                print(serializationError.localizedDescription)
            }
            
        }.resume()
        return cityWeather
    }
}

