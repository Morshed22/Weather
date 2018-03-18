//
//  AppServerClient.swift
//  WeatherForeCast
//
//  Created by Morshed Alam on 13/2/18.
//  Copyright © 2018 GG. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class AppServerClient {

static func setUrlPathComponent(url:URL,params: [(String, String)])-> URLComponents{
    var queryItems = params.map { URLQueryItem(name: $0.0, value: $0.1) }
    let keyQueryItem = URLQueryItem(name: "appid", value: Constants.APPID)
    let unitsQueryItem = URLQueryItem(name: "units", value: "metric")
    queryItems.append(keyQueryItem)
    queryItems.append(unitsQueryItem)
    var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
    urlComponents.queryItems =   queryItems
    return urlComponents
}

private struct Constants {
    static let APPID = "b7df09399978c6080aa16b2af36a5f32"
    static let baseURL = "http://api.openweathermap.org/"
}
enum ResourcePath: String {
    case Forecast = "data/2.5/forecast"
    case CurrentWeather = "data/2.5/weather"
    
    var path: String {
        return Constants.baseURL + rawValue
    }
}

    
    
// Weekly Weather

enum WeekyDataFailureReason: Int, Error {
    case invalidkey = 401
    case notFound = 404
}




typealias WeeklyResult = Result<Weather, WeekyDataFailureReason>
typealias WeeklyResultCompletion = (_ result: WeeklyResult) -> Void

func getWeeklyDataforLastFiveDays(params: [(String, String)], completion: @escaping WeeklyResultCompletion){
    
    let urlComponent = AppServerClient.setUrlPathComponent(url: URL(string:ResourcePath.Forecast.path)!, params: params)
    
    Alamofire.request((urlComponent.url?.absoluteString)!, method:.get, parameters:nil, encoding: JSONEncoding.default)
        .validate(statusCode: 200 ..< 300)
        .responseJSON{ response in
            //print(response.request?.url?.absoluteString)
            switch response.result {
            case .success:
                guard let json = response.result.value, let swiftyJSON = JSON(rawValue: json),
                    let weather = Weather(json: swiftyJSON) else {
                        completion(.failure(nil))
                        return
                }
                completion(.success(payload:weather))
            case .failure(_):
                if let statusCode = response.response?.statusCode,
                    let reason = WeekyDataFailureReason(rawValue: statusCode) {
                    completion(.failure(reason))
                }
                completion(.failure(nil))
            }
    }
    
}


// Current Weather
    
enum TodayDataFailureReason: Int, Error {
    case invalidkey = 401
    case notFound = 404
}

typealias TodayResult = Result<TodayWeather, TodayDataFailureReason>
typealias TodayResultCompletion = (_ result: TodayResult) -> Void



func setTodayWeather(params: [(String, String)], completion: @escaping TodayResultCompletion){
    
    let urlComponent = AppServerClient.setUrlPathComponent(url:URL(string:ResourcePath.CurrentWeather.path)!, params: params)
    Alamofire.request((urlComponent.url?.absoluteString)!, method:.get, parameters:nil, encoding: JSONEncoding.default)
        .validate(statusCode: 200 ..< 300)
        .responseJSON { response in
            
            switch response.result {
            case .success:
                guard let json = response.result.value, let swiftyJSON = JSON(rawValue: json),
                    let currentWeather = TodayWeather(json: swiftyJSON) else {
                        completion(.failure(nil))
                        return
                }
                completion(.success(payload:currentWeather))
            case .failure(_):
                if let statusCode = response.response?.statusCode,
                    let reason = TodayDataFailureReason(rawValue: statusCode) {
                    completion(.failure(reason))
                }
                completion(.failure(nil))
            }
    }
}

}
