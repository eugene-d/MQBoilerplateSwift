//
//  MQError.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/19/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

public let kMQGenericErrorCode: Int = -1

open class MQError : NSError {
    
    public enum Code: Int {
        case generic = -1
        case unexpected = -2
    }
    
//    public init(message: String) {
//        // Set the error's domain property.
//        var domain: String
//        if let bundleID = NSBundle.mainBundle().bundleIdentifier {
//            domain = bundleID
//        } else {
//            domain = ""
//        }
//        
//        super.init(domain: domain, code: kMQGenericErrorCode, userInfo: [NSLocalizedDescriptionKey : message])
//    }
    
    public init(_ message: String, code: Code) {
        // Set the error's domain property.
        var domain: String
        if let bundleID = Bundle.main.bundleIdentifier {
            domain = bundleID
        } else {
            domain = ""
        }
        
        super.init(domain: domain, code: code.rawValue, userInfo: [NSLocalizedDescriptionKey : message])
    }
    
    public convenience init(_ message: String) {
        self.init(message, code: .generic)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
