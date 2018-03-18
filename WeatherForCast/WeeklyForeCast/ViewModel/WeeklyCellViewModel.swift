//
//  WeeklyCellViewModel.swift
//  WeatherForeCast
//
//  Created by Morshed Alam on 13/2/18.
//  Copyright © 2018 GG. All rights reserved.
//

import Foundation



protocol WeeklyCellViewModel {
    
    //var forCast: Forecast { get }
    var tempStr:String{ get }
    var msg:String { get }
    //var weeklyWeather: Weather { get }
}

extension Forecast: WeeklyCellViewModel{
    
        //var forCast: Forecast {
      //  return self
    //}
    var tempStr: String {
       return String(self.temp)
    }
    var msg : String{
        return self.description
    }
    
    
//    var weeklyWeather: Weather {
//        return self
//    }
    
    
   
}
