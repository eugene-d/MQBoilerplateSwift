//
//  MQCommand.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/15/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

public class MQCommand {
    
    public var processBlock: (() -> ())?
    public var completionBlock: (() -> ())?
    public var successBlock: ((AnyObject?) -> ())?
    public var failureBlock: ((NSError) -> ())?
    
    public var result: AnyObject?
    public var error: NSError?
    
    public init() {}
    
    public func process() {}
    
    public func execute() {
        // If a processBlock has been supplied, execute that.
        // Otherwise, execute the overridden process() function.
        if let processBlock = self.processBlock {
            processBlock()
        } else {
            self.process()
        }
        
        // Perform the completionBlock if supplied.
        if let completionBlock = self.completionBlock {
            completionBlock()
        }
        
        // Depending on whether an error occurred or not, execute either the
        // failure block or the success block.
        if let error = self.error {
            if let failureBlock = self.failureBlock {
                failureBlock(error)
            }
        } else {
            if let successBlock = self.successBlock {
                successBlock(self.result)
            }
        }
    }
    
}