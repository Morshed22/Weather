//
//  TodayWeatherTests.swift
//  WeatherForeCastTests
//
//  Created by Morshed Alam on 17/2/18.
//  Copyright © 2018 GG. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import WeatherForeCast

class TodayWeatherTests: XCTestCase {
   
  
    func testTodayWeather(){

        let currentWeather: JSON = [
            "name":"Dhaka",
            "main":["temp":22.21],
            "weather":[["description" : "Clear Sky"]],
            "wind":["deg":325.0]
    ]

        
        XCTAssertNotNil(TodayWeather(json:currentWeather))
        
        
    }
}
