//
//  AlertTests.swift
//  WeatherForeCastTests
//
//  Created by Morshed Alam on 17/2/18.
//  Copyright © 2018 GG. All rights reserved.
//

import XCTest
@testable import WeatherForeCast

class AlertTests: XCTestCase {
    
    func testAlert() {
        let expectAlertActionHandlerCall = expectation(description: "Alert action handler called")
        
        let alert = SingleButtonAlert(
            title: "",
            message: "",
            action: AlertAction(buttonTitle: "", handler: {
                expectAlertActionHandlerCall.fulfill()
            })
        )
        
        alert.action.handler!()
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }

    
}
