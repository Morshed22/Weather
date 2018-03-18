//
//  WeeklyDataTableViewModelTest.swift
//  WeatherForeCastTests
//
//  Created by Morshed Alam on 17/2/18.
//  Copyright © 2018 GG. All rights reserved.
//

import XCTest

@testable import WeatherForeCast



class WeeklyDataTableViewModelTest: XCTestCase {

    func testForNormalCells() {
        
        let appServerClient = MockAppServerClient()
        appServerClient.weeklyeResult = .success(payload:Weather.with())

       let viewModel = WeeklyDataTableViewModel(appServerClient: appServerClient)
       viewModel.getWeeklyData(params: [("lat", "\(45.00)"), ("lon", "\(35.87)")])

        guard case .some(.normal(_)) = viewModel.dayWiseForcating.value.first else{
            XCTFail()
            return
        }
    }

    func testEmptyCells() {
        let appServerClient = MockAppServerClient()
        appServerClient.weeklyeResult = .success(payload:Weather.with(cityName: "", forcast: []))

    let viewModel = WeeklyDataTableViewModel(appServerClient: appServerClient)
        viewModel.getWeeklyData(params: [("lat", "\(45.00)"), ("lon", "\(35.87)")])
        
        guard case .some(.empty) = viewModel.dayWiseForcating.value.first else {
            XCTFail()
            return
        }
    }
    
    func testErrorCells() {
        
     let appServerClient = MockAppServerClient()
       appServerClient.weeklyeResult = .failure(AppServerClient.WeekyDataFailureReason.notFound)
  
    let viewModel = WeeklyDataTableViewModel(appServerClient: appServerClient)
        viewModel.getWeeklyData(params: [("lat", "\(45.00)"), ("lon", "\(35.87)")])
        
        guard case .some(.error) = viewModel.dayWiseForcating.value.first else {
            XCTFail()
            return
        }

    }
    
    private final class MockAppServerClient: AppServerClient {
        var weeklyeResult: AppServerClient.WeeklyResult?
        
 
        override func getWeeklyDataforLastFiveDays(params: [(String, String)], completion: @escaping AppServerClient.WeeklyResultCompletion) {
            completion(weeklyeResult!)
        }
 
    }
    
    
    
    
}
