//
//  Weather.swift
//  WeatherForeCast
//
//  Created by Morshed Alam on 13/2/18.
//  Copyright © 2018 GG. All rights reserved.
//

import Foundation
import SwiftyJSON



struct Forecast {
    
    let date: NSDate
    let temp: Float
    let description: String
}

extension Forecast{
    
    init?(json: JSON) {
        guard
            let timestamp = json["dt"].double,
            let temp = json["main"]["temp"].float,
            let description = json["weather"][0]["description"].string
            else {
                return nil
        }
        
        self.date = NSDate(timeIntervalSince1970: timestamp)
        self.temp = temp
        self.description = description
    }
}


struct Weather {
    
    let cityName: String
    let forecasts: [Forecast]
    
}
extension Weather{
    
    init?(json: JSON) {
        
        guard  let cityName = json["city"]["name"].string,
            let forecastData = json["list"].array
            else {
                return nil
        }
        
        
        self.cityName = cityName
        let forecasts = forecastData.flatMap(Forecast.init)
        guard !forecasts.isEmpty else {
            return nil
        }
        
        self.forecasts = forecasts
    }
}


