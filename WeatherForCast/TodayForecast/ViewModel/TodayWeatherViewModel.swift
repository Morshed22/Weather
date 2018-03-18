//
//  TodayWeatherViewModel.swift
//  WeatherForeCast
//
//  Created by Morshed Alam on 14/2/18.
//  Copyright © 2018 GG. All rights reserved.
//

import Foundation

class TodayWeatherViewModel  {

    let appServerClient: AppServerClient
    var onShowError: ((_ alert: SingleButtonAlert) -> Void)?
    let showLoadingHud: Bindable = Bindable(false)
    let description = Bindable(String.init())
    var temp = Bindable(String.init())
    let windDirection = Bindable(String.init())
    var cityName = Bindable(String.init())
    
    
    // set wind direction from degree
    
     func getWindDirection(deg:Float) -> String{
        let direction:[String] = ["N", "NNE",  "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
    
        let value = (deg + 11.25)/22.5
        let i = value.truncatingRemainder(dividingBy: 16)
        return direction[Int(i)]
    }
    
    
    init(appServerClient: AppServerClient = AppServerClient()) {
        self.appServerClient = appServerClient
    }
    // current weather of city with lat anad lon
    func getCurrentWeatherData(params: [(String, String)]){
        showLoadingHud.value = true
        appServerClient.setTodayWeather(params:params){ [weak self] result in
            guard let strongSelf = self  else { return }
            strongSelf.showLoadingHud.value = false
            switch result {
            case .success(let data):
                strongSelf.description.value = data.description
                strongSelf.temp.value = String(data.temperature) + "° C"
                strongSelf.cityName.value = data.cityName
                strongSelf.windDirection.value = strongSelf.getWindDirection(deg: data.degree)

            case .failure(let error):
                let okAlert = SingleButtonAlert(
                    title: error?.getErrorMessage() ?? "Could not connect to server. Check your network and try again later.",
                    message: "Failed to update information.",
                    action: AlertAction(buttonTitle: "OK", handler: { print("Ok pressed!") })
                )
                self?.onShowError?(okAlert)
            }
        }
        
    }
    

    
}

// failur message
fileprivate extension AppServerClient.TodayDataFailureReason {
    func getErrorMessage() -> String? {
        switch self {
        case .invalidkey:
            return "Your Key is Invalid"
        case .notFound:
            return "Api Key is missing "
        }
    }
}
