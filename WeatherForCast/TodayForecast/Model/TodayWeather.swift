//
//  TodayWeather.swift
//  WeatherForeCast
//
//  Created by Morshed Alam on 14/2/18.
//  Copyright © 2018 GG. All rights reserved.
//

import Foundation
import SwiftyJSON


struct TodayWeather {
    
    let cityName:String
    let temperature:Float
    let description:String
    let degree:Float
}

extension TodayWeather{
    init?(json: JSON) {
        guard
            let cityName = json["name"].string,
        let temperature = json["main"]["temp"].float,
        let description = json["weather"][0]["description"].string,
        let degree     =     json["wind"]["deg"].float
        else {
            return nil
        }
        self.cityName = cityName
        self.description = description
        self.temperature = temperature
        self.degree = degree

    }
}
