//
//  MockWeather.swift
//  WeatherForeCast
//
//  Created by Morshed Alam on 17/2/18.
//  Copyright © 2018 GG. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Weather{

    static func with(cityName:String = "Dhaka", forcast:[Forecast] = [Forecast.with()]) -> Weather{
        
    return Weather(cityName: cityName, forecasts: forcast)

    }
}

extension Forecast{
    
    static func with(
        
        date : NSDate = NSDate(timeIntervalSince1970: 14844),
        temp:Float = 22.5,
        des:String = "clear sky" ) ->Forecast{
        
        return Forecast(date: date, temp: temp, description: des)
    }
    
}
    
    


