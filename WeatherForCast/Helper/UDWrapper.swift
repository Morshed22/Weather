//
//  UDWrapper.swift
//  WeatherForeCast
//
//  Created by Morshed Alam on 15/2/18.
//  Copyright © 2018 GG. All rights reserved.
//

import Foundation

class UDWrapper{
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Get value
    //------------------
    
    class func getString(key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Set value
    //-------------------------------------------------------------------------------------------
    
  
    class func setString(key: String, value: NSString?) {
        if (value == nil) {
            UserDefaults.standard.removeObject(forKey: key)
        } else {
            UserDefaults.standard.set(value, forKey: key)
        }
        UserDefaults.standard.synchronize()
    }
    
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Synchronize
    //-------------------------------------------------------------------------------------------
    
    class func Sync() {
        UserDefaults.standard.synchronize()
    }
}
