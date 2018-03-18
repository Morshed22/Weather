//
//  TodayWeatherViewModelTests.swift
//  WeatherForeCastTests
//
//  Created by Morshed Alam on 17/2/18.
//  Copyright © 2018 GG. All rights reserved.
//

import XCTest

@testable import WeatherForeCast

class TodayWeatherViewModelTests: XCTestCase {

    
    
    func testForCurrentWeatherSuccess() {
        
        let appServerClient = MockAppServerClient()
        appServerClient.daillyResult = .success(payload: TodayWeather.with())
        
    
        let viewModel = TodayWeatherViewModel(appServerClient: appServerClient)
        viewModel.getCurrentWeatherData(params: [("lat", "\(45.00)"), ("lon", "\(35.87)")])
        
        XCTAssertNotNil(viewModel.cityName, "city name not found")
        XCTAssertNotNil(viewModel.description, "Description not found")
        XCTAssertNotNil(viewModel.temp, "temperature not found")
        XCTAssertNotNil(viewModel.windDirection,"wind direction not found")
   
    }
    

    func testForCurrentWeatherFailure() {

        let appServerClient = MockAppServerClient()
        appServerClient.daillyResult = .failure(nil)
        


        let viewModel = TodayWeatherViewModel(appServerClient: appServerClient)
        
        viewModel.getCurrentWeatherData(params: [("lat", "\(45.00)"), ("lon", "\(35.87)")])
 
        
        viewModel.onShowError = { error in
          XCTAssertNotNil(error)
        }
      
    }
    
    
    
    private final class MockAppServerClient: AppServerClient {
        
        var daillyResult: AppServerClient.TodayResult?
        
        
        override func setTodayWeather(params: [(String, String)], completion: @escaping AppServerClient.TodayResultCompletion) {
            completion(daillyResult!)
        }
    }
}
