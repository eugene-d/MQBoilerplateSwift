//
//  MQError.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/19/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

public let kMQGenericErrorCode: Int = -1

public class MQError : NSError {
    
    public init(message: String) {
        // Set the error's domain property.
        var domain: String
        if let bundleID = NSBundle.mainBundle().bundleIdentifier {
            domain = bundleID
        } else {
            domain = ""
        }
        
        super.init(domain: domain, code: kMQGenericErrorCode, userInfo: [NSLocalizedDescriptionKey : message])
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}