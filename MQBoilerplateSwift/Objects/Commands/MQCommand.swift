//
//  MQCommand.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/15/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

public class MQCommand {
    
    /**
    Defines the main task of this command and called when execute() is called.
    If supplied, calling execute() WILL NOT call the process() function.
    This property is provided for cases when you don't want to subclass MQCommand.
    */
    public var processBlock: (() -> Void)?
    
    /**
    Tasks that need to be executed after the process regardless of whether
    the command succeeds or fails. This block is called before either the successBlock
    or the failureBlock.
    
    Examples of what to do in a completion block are closing input/output streams,
    or hiding a screen's "Loading" view before either showing the results or an error message.
    */
    public var completionBlock: (() -> Void)?
    
    /**
    Executed when no errors occur, with or without a result.
    This is performed after the completionBlock.
    */
    public var successBlock: ((AnyObject?) -> Void)?
    
    /**
    Executed when an error occurs during processing.
    */
    public var failureBlock: ((NSError) -> Void)?
    
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