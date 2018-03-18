//
//  WeatherTest.swift
//  WeatherForeCastTests
//
//  Created by Morshed Alam on 17/2/18.
//  Copyright © 2018 GG. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import WeatherForeCast

class WeatherTest: XCTestCase {
    
   let forcastData:JSON = [
    
            "dt": 84574.9934,
            "main":["temp":22.5],
            "weather":[["description":"cloudySky"]]
            ]
    
    func testWeeklyWeather(){

        let weeklyWeathertestData:JSON = [
            "city":["name":"Dhaka"],
            "list":[forcastData]
        ]

         XCTAssertNotNil(Weather(json: weeklyWeathertestData))

        
    }
    
   func testForcast(){
    
           XCTAssertNotNil(Forecast(json: forcastData))
    }
    
    
}

