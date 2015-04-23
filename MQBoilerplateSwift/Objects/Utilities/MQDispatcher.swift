//
//  MQDispatcher.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/23/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

public class MQDispatcher {
    
    public class func executeInMainThread(block: () -> Void) {
        dispatch_async(dispatch_get_main_queue(), {
            block()
        })
    }
    
}