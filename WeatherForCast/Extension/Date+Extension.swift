//
//  Date+Extension.swift
//  WeatherForeCast
//
//  Created by Morshed Alam on 13/2/18.
//  Copyright © 2018 GG. All rights reserved.
//

import Foundation

extension NSDate {
    
    ///Returns the time of a date formatted as "HH:mm" (e.g. 18:30)
    func formattedTime(formatter: DateFormatter)-> String {
        formatter.setLocalizedDateFormatFromTemplate("HH:mm")
        return formatter.string(from: self as Date)
    }
    
    ///Returns a string in "d M" format, e.g. 19/9 for June 19.
    func formattedDay(formatter: DateFormatter)-> String {
        //the reason formatter is injected is because creating an
        //NSDateFormatter instance is pretty expensive
        formatter.setLocalizedDateFormatFromTemplate("d M")
        return formatter.string(from: self as Date)
    }
    
    ///Returns the week day of the NSDate, e.g. Sunday.
    func dayOfWeek(formatter: DateFormatter)-> String {
        //the reason formatter is injected is because creating an
        //NSDateFormatter instance is pretty expensive
        formatter.setLocalizedDateFormatFromTemplate("EEEE")
        return formatter.string(from: self as Date)
    }
}


//MARK: - Comparable

extension NSDate: Comparable {}

func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.isEqual(to: rhs as Date)
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.earlierDate(rhs as Date) == lhs as Date
}

