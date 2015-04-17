//
//  NSCharacterSet.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/18/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

public extension NSCharacterSet {
    
    public class func numberCharacterSet() -> NSCharacterSet {
        return NSCharacterSet(charactersInString: "1234567890")
    }
    
}