//
//  NSLayoutConstraint+MQBoilerplateSwiftExtensions.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/17/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

public extension NSLayoutConstraint {
    
    public class func constraintsWithVisualFormatArray(array: [String], metrics: [String: AnyObject]?, views: [String: AnyObject]) -> [AnyObject] {
        var constraints = NSMutableArray()
        for rule in array {
            constraints.addObjectsFromArray(self.constraintsWithVisualFormat(rule,
                options: .DirectionLeadingToTrailing,
                metrics: metrics,
                views: views))
        }
        
        return constraints as [AnyObject]
    }
    
}