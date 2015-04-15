//
//  MQAlertingHTTPCommand.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/15/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

public class MQAlertingHTTPCommand: MQAlertingCommand {
    
    /**
    The execute() function of an MQAlertingHTTPCommand only executes the processBlock or the process()
    function. The developer is exepected to manually define an asynchronous HTTP request
    and when it should execute the completion, success, and failure blocks.
    */
    override public func execute() {
        if let processBlock = self.processBlock {
            processBlock()
        } else {
            self.process()
        }
    }
    
}