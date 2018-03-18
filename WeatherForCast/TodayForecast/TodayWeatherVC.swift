//
//  TodayWeatherVC.swift
//  WeatherForeCast
//
//  Created by Morshed Alam on 14/2/18.
//  Copyright © 2018 GG. All rights reserved.
//

import Foundation
import UIKit
import PKHUD
import CoreLocation

class TodayWeatherVC: UIViewController {

    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    
    let viewModel: TodayWeatherViewModel = TodayWeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
          bindViewModel()
       
    }
    
    // updating data with location and APi hit
    func UpdateTodayWeatherData(location:CLLocation){
        DispatchQueue.once {
                let lat = location.coordinate.latitude
                let lon = location.coordinate.longitude
                self.viewModel.getCurrentWeatherData(params: [("lat", "\(lat)"), ("lon", "\(lon)")])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Reachability.isReachable{
            if let location = LocationService.sharedInstance.currentLocation{
                UpdateTodayWeatherData(location:location)
        }
    }
}
    
    // binding the ViewModel
    
    private func bindViewModel(){
        
        viewModel.description.bind{ [weak self] description in
            
            self?.descriptionLabel.text = description
        }
        
        viewModel.temp.bind{ [weak self] temperature in
            
            self?.tempLabel.text = temperature
        }
        
        viewModel.cityName.bind{ [weak self] cityName in
            
            self?.cityNameLabel.text = cityName
        }
        
        viewModel.windDirection.bind{ [weak self] windDirection in
            
            self?.windDirectionLabel.text = windDirection
        }
        
        
       
        viewModel.onShowError = { [weak self] alert in
            self?.presentSingleButtonDialog(alert: alert)
        }
        
        viewModel.showLoadingHud.bind() { visible in
            print(visible)
            PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
            visible ? PKHUD.sharedHUD.show() : PKHUD.sharedHUD.hide()
        }
        
    }
    
    
    
    
    
    
}



