//
//  AppDelegate.swift
//  WeatherForCast
//
//  Created by Morshed Alam on 13/2/18.
//  Copyright © 2018 GG. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseCore
import CoreLocation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
    
     let locationInstance = LocationService.sharedInstance
        locationInstance.delegate = self
        locationInstance.startUpdatingLocation()
        
      Reachability.listenForReachability()
        
        FirebaseApp.configure()
        
//    GIDSignIn.sharedInstance().clientID = "662202657787-dd5tq1o61n657ga3sei5p3i533tnhpbd.apps.googleusercontent.com"
    GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
   
     
    if FBSDKAccessToken.current() != nil {
        self.setTabVCtoRootController()
        
    }else if let signIn = GIDSignIn.sharedInstance(){
        signIn.scopes = ["https://www.googleapis.com/auth/plus.login"]
        if signIn .hasAuthInKeychain(){
            signIn.signInSilently()
            self.setTabVCtoRootController()
        }
    }
   
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func setTabVCtoRootController(){
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabVC = mainStoryboard.instantiateViewController(withIdentifier: "tabVC") as! UITabBarController
        tabVC.selectedIndex = 0
        self.window?.makeKeyAndVisible()
        delay(delay: 0.1) {
            self.window?.rootViewController = tabVC
        }
        
        
    }
    
}

extension AppDelegate:LocationServiceDelegate{
    
    func tracingLocation(_ currentLocation: CLLocation){
        print(currentLocation)
        
        
    }
    func tracingLocationDidFailWithError(_ error: NSError) {
        print(error.localizedDescription)
        //self.showLocationAlert()
    }
}

