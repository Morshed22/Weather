//
//  MockTodayWeather.swift
//  WeatherForeCastTests
//
//  Created by Morshed Alam on 17/2/18.
//  Copyright © 2018 GG. All rights reserved.
//

import Foundation

extension TodayWeather{
    
  static func with( cityName:String = "Dhaka",temp:Float = 22.5, des:String = "Cloudy", deg:Float = 324)->TodayWeather{
        
        return TodayWeather(cityName: cityName, temperature: temp, description: des, degree: deg)
        
    }
    
    
}

