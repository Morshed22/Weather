//
//  WeeklyDataViewModel.swift
//  WeatherForeCast
//
//  Created by Morshed Alam on 13/2/18.
//  Copyright © 2018 GG. All rights reserved.
//

import Foundation

//typealias dayWiseForCastData = [(day: String, forecasts: [ForecastModel])]

class WeeklyDataTableViewModel {
    
    
    enum WeeklyDataTableViewCellType {
        //case normal(cellViewModel: WeeklyCellViewModel)
        case normal(cellValue:(day: String, forecasts: [ForecastModel]))
        case error(message: String)
        case empty
 }
    fileprivate let formatter = DateFormatter()
    var onShowError: ((_ alert: SingleButtonAlert) -> Void)?
    let showLoadingHud: Bindable = Bindable(false)
    
    //let weeklyDatacells = Bindable([WeeklyDataTableViewCellType]())
    let dayWiseForcating = Bindable([WeeklyDataTableViewCellType]())
    let navTitle:Bindable = Bindable(String.init())
    let appServerClient: AppServerClient
    
    init(appServerClient: AppServerClient = AppServerClient()) {
        self.appServerClient = appServerClient
    }
    func getWeeklyData(params: [(String, String)]) {
        showLoadingHud.value = true
        appServerClient.getWeeklyDataforLastFiveDays(params:params){ [weak self] result in
           self?.showLoadingHud.value = false
            switch result {
            case .success(let data):
                self?.navTitle.value = data.cityName
                guard  data.forecasts.count > 0, let cellData =  self?.cells(from: data) else {
                   // self?.dayWiseForcating.value = [.empty]
                    self?.dayWiseForcating.value = [.empty]
                    return
                }
//                self?.weeklyDatacells.value = data.forecasts.flatMap { .normal(cellViewModel: $0 as WeeklyCellViewModel)}
                self?.dayWiseForcating.value = cellData.flatMap{.normal(cellValue: $0) }
               
            case .failure(let error):
                self?.dayWiseForcating.value = [.error(message: error?.getErrorMessage() ?? "Loading failed, check network connection")]
            }
        }
    }
    


private func cells(from weather: Weather)-> [(day: String, forecasts: [ForecastModel])]{
    
    //There's probably a better way to write this.
    
    func dateTimestampFromDate(date: NSDate)-> String {
        formatter.dateFormat = "YYMMdd HHmm"
        return formatter.string(from: date as Date)
    }
    
    func dayTimestampFromDateTimstamp(timestamp: String)-> String {
        //print(timestamp)
        return String(describing: timestamp.split(separator: " ")[0])
    }
    
    let allTimestamps = weather.forecasts
       // .map {print{$0.date)}
        .map { $0.date }
        .map(dateTimestampFromDate)
    
    //print(allTimestamps)
    
    let uniqueDayTimestamps = allTimestamps
        .map(dayTimestampFromDateTimstamp)
        .uniqueElements
    
    let forecastsForDays = uniqueDayTimestamps.map { day in
        return weather.forecasts.filter { forecast in
            let forecastTimestamp = dateTimestampFromDate(date: forecast.date)
            let dayOfForecast = dayTimestampFromDateTimstamp(timestamp: forecastTimestamp)
            
            return dayOfForecast == day
        }
    }
    
    let forecastModels = forecastsForDays.map { forecasts in
        return forecasts.map(forecastModel)
    }
    
    let dayStrings = weather.forecasts
        .map { $0.date.dayOfWeek(formatter: formatter) }
        .uniqueElements
    
    //Combine those two Arrays into an Array of tuples
    return Array(zip(dayStrings, forecastModels))
}

 private func forecastModel(from forecast: Forecast)-> ForecastModel {
    return ForecastModel(
        time: "ti: \(forecast.date.formattedTime(formatter: formatter))",
        description: "de: \(forecast.description)",
        temp: "te: \(forecast.temp)° C")
 }
    
}

private extension AppServerClient.WeekyDataFailureReason {
    func getErrorMessage() -> String? {
        switch self {
        case .invalidkey:
            return "Your key is not valid"
        case .notFound:
            return "Failed to add friend. Please try again."
        }
    }
}

