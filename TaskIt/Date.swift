//
//  Date.swift
//  TaskIt
//
//  Created by Frank Lee on 2014-09-26.
//  Copyright (c) 2014 franklee. All rights reserved.
//

import Foundation
import UIKit

class Date {
    //add #
    class func from (#year:Int, month: Int, day: Int) -> NSDate {
        
        var components = NSDateComponents ()
        components.year = year
        components.month = month
        components.day = day
        
        var gregorianCalendar = NSCalendar(identifier: NSGregorianCalendar)!
        var date = gregorianCalendar.dateFromComponents(NSDateComponents())
    
        
        return date!
    }
    
    class func toString(#date:NSDate) -> String {
        
        let dateStringFormatter = NSDateFormatter ()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateStringFormatter.stringFromDate(date)
        return dateString
    }
    
}
