//
//  City.swift
//  BlubDeveloperTest
//
//  Created by Marko Pranjić on 23/03/2020.
//  Copyright © 2020 Marko Pranjić. All rights reserved.
//

import Foundation

class CityWeather: Codable {
    var name: String
    var temperature: Int?
    var humidity: Int?
    var description: String?
    
    init() {
        name = "Unasigned"
    }
    
    init(name: String) {
        self.name = name
    }
    
    func setTemperature(temp: Double){
        temperature = (Int)(temp - 273.15)
    }
    
}
