//
//  NSDate.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 7/13/15.
//  Copyright © 2015 Matt Quiros. All rights reserved.
//

import Foundation

public extension NSDate {
    
    public func isSameDayAsDate(date: NSDate) -> Bool {
        let calendar = NSCalendar.currentCalendar()
        // FIXME: Swift 2.0
//        let components: NSCalendarUnit = [.Month, .Day, .Year]
        let components: NSCalendarUnit = .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitYear
        
        let thisDate = calendar.components(components, fromDate: self)
        let otherDate = calendar.components(components, fromDate: date)
        
        return thisDate.month == otherDate.month &&
            thisDate.day == otherDate.day &&
            thisDate.year == otherDate.year
    }
    
}