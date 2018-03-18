//
//  Reachability.swift
//  WeatherForeCast
//
//  Created by Morshed Alam on 16/2/18.
//  Copyright © 2018 GG. All rights reserved.
//


import Foundation
import SystemConfiguration
import Alamofire



//protocol InterStatusCheking {
//
//    func showStatus(value:Bool)
//}


var Host = "openweathermap.org"

enum ReachabilityType: CustomStringConvertible {
    case wwan
    case wiFi
    
    var description: String {
        switch self {
        case .wwan: return "WWAN"
        case .wiFi: return "WiFi"
        }
    }
}

enum ReachabilityStatus: CustomStringConvertible  {
    case offline
    case online(ReachabilityType)
    case unknown
    
    var description: String {
        switch self {
        case .offline: return "Offline"
        case .online(let type): return "Online (\(type))"
        case .unknown: return "Unknown"
        }
    }
}

open class Reachability:NSObject{
    
   
    
    static var isReachable = false
    static var status:ReachabilityStatus?
    static let internetStatusChangedNotification = NSNotification.Name(rawValue: "internetStatusChangedNotification")
    
    static let reachabilityManager = Alamofire.NetworkReachabilityManager(host: Host)
    static var delay = 10.0
    static var onGoing = false
    static var firstTime = true
     //static var interStatus:InterStatusCheking?
    
    static func monitorReachabilityChanges() {
        let host = Host
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        let reachability = SCNetworkReachabilityCreateWithName(nil, host)!
        
        SCNetworkReachabilitySetCallback(reachability, { (_, flags, _) in
            let status = ReachabilityStatus(reachabilityFlags: flags)
            Reachability.status = status
            Reachability.isReachable = status.description == "Offline" ? false : true
            NotificationCenter.default.post(name: Reachability.internetStatusChangedNotification,
                                            object: nil,
                                            userInfo: ["Status": status.description])
            
        }, &context)
        
        SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetMain(), CFRunLoopMode.commonModes.rawValue)
    }
    
    static func listenForReachability() {
        
        reachabilityManager?.listener = { status in
            //            print("Network Status Changed: \(status)")
            switch status {
            case .notReachable:
                isReachable = false
                showInterNetNotification(isReachable: isReachable)
                NotificationCenter.default.post(name: Reachability.internetStatusChangedNotification, object: nil)
                
            case .reachable(_), .unknown:
                isReachable = true
                showInterNetNotification(isReachable: isReachable)
                NotificationCenter.default.post(name: Reachability.internetStatusChangedNotification, object: nil)
               
                break
            }
        }
        
        reachabilityManager?.startListening()
    }
    
    //---------------------------------------------------
    // MARK:- Prohibit Swift Message for ChatviewController
    //---------------------------------------------------
    
    
    static func showInterNetNotification(isReachable: Bool) {
        if isReachable && !Reachability.firstTime {
           // interStatus?.showStatus(value: true)
            
            return
        }
        if Reachability.onGoing == true {
            return
        }
        Reachability.onGoing = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Reachability.delay) {
           
                if Reachability.isReachable {
                   // interStatus?.showStatus(value: true)
                } else {
                   // interStatus?.showStatus(value: false)
                }
            
            Reachability.onGoing = false
            Reachability.firstTime = false
        }
    }
}


extension ReachabilityStatus {
    fileprivate init(reachabilityFlags flags: SCNetworkReachabilityFlags) {
        let connectionRequired = flags.contains(.connectionRequired)
        let isReachable = flags.contains(.reachable)
        let isWWAN = flags.contains(.isWWAN)
        
        if !connectionRequired && isReachable {
            if isWWAN {
                self = .online(.wwan)
            } else {
                self = .online(.wiFi)
            }
        } else {
            self =  .offline
        }
    }
}
