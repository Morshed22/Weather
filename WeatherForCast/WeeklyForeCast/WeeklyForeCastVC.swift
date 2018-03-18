//
//  WeeklyForeCastVC.swift
//  WeatherForeCast
//
//  Created by Morshed Alam on 13/2/18.
//  Copyright © 2018 GG. All rights reserved.
//

import UIKit
import CoreLocation
import PKHUD

struct ForecastModel {
    let time: String
    let description: String
    let temp: String
}

class WeeklyForeCastVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel: WeeklyDataTableViewModel = WeeklyDataTableViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
        
        
    }
    
    
    // checking location and connection
    func checkLocationAndConnection(){
        if !Reachability.isReachable{
            showInternetAlert()
        }
        if !LocationService.isLocationServiceEnabled(){
            showLocationAlert()
        }
    }
    
    
    // bind view  model
    func bindViewModel() {
        
        viewModel.navTitle.bind(){ [weak self] title in
            self?.navigationItem.title = title
        }
        
        viewModel.dayWiseForcating.bindAndFire() { [weak self] _ in
            self?.tableView?.reloadData()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Reachability.isReachable{
        if let location = LocationService.sharedInstance.currentLocation {
           UpdateWeeklyWeatherData(location: location)
        }
    }
}
 
     // Api hit and update weather data
    func UpdateWeeklyWeatherData(location:CLLocation){
        
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            DispatchQueue.once {
             viewModel.getWeeklyData(params: [("lat", "\(lat)"), ("lon", "\(lon)")])
            }
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
   
    
}
// tableview datasource
extension WeeklyForeCastVC: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.dayWiseForcating.value.count
    }

    
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch viewModel.dayWiseForcating.value[section] {
    case .normal(let cellValue):
        return cellValue.forecasts.count
    default:
        return 0
    }
}
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch viewModel.dayWiseForcating.value[indexPath.section]{
        case .normal(let cellValue):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeeklyTableViewCell") as? WeeklyTableViewCell else {
                return UITableViewCell()
            }
            let forecast = cellValue.forecasts[indexPath.row]
            cell.configureCell(forecast.temp, time: forecast.time, des: forecast.description)
            return cell
          
        case .error(let message):
            let cell = UITableViewCell()
            cell.isUserInteractionEnabled = false
            cell.textLabel?.text = message
            return cell
        case .empty:
            let cell = UITableViewCell()
            cell.isUserInteractionEnabled = false
            cell.textLabel?.text = "No data available"
            return cell
        
         
        }
    }
    
}
// tableview delegate

extension WeeklyForeCastVC:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch viewModel.dayWiseForcating.value[section] {
        case .normal(let cellValue):
            return cellValue.day
        default:
            return nil
        }
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
 
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}

